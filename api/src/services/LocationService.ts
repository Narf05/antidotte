import { db } from '../db/client'
import { WSServer } from '../websocket/WSServer'

export class LocationService {
  static async updatePresence(userId: string, lat: number, lon: number, accuracyM: number): Promise<void> {
    const [settings] = await db`
      SELECT panic_privacy_active, location_sharing_enabled, location_precision, share_during_sessions_only
      FROM privacy_settings WHERE user_id = ${userId}
    `

    if (!settings?.location_sharing_enabled || settings.panic_privacy_active) {
      await db`
        UPDATE live_location_presence
        SET presence_state = 'hidden', last_seen_at = now()
        WHERE user_id = ${userId}
      `
      return
    }

    const approx = LocationService.applyApproximation(lat, lon)

    const [activeSession] = await db`
      SELECT id FROM night_out_sessions
      WHERE user_id = ${userId} AND is_active = true
      LIMIT 1
    `

    if (settings.share_during_sessions_only && !activeSession) {
      return
    }

    await db`
      INSERT INTO live_location_presence
        (user_id, session_id, last_seen_at, latitude, longitude,
         rough_area_latitude, rough_area_longitude, presence_state)
      VALUES
        (${userId}, ${activeSession?.id ?? null}, now(), ${lat}, ${lon},
         ${approx.lat}, ${approx.lon}, 'live')
      ON CONFLICT (user_id) DO UPDATE SET
        session_id = EXCLUDED.session_id,
        last_seen_at = now(),
        latitude = EXCLUDED.latitude,
        longitude = EXCLUDED.longitude,
        rough_area_latitude = EXCLUDED.rough_area_latitude,
        rough_area_longitude = EXCLUDED.rough_area_longitude,
        presence_state = 'live',
        stale_since = NULL
    `

    await db`
      INSERT INTO location_samples
        (user_id, session_id, sampled_at, latitude, longitude, accuracy_m)
      VALUES
        (${userId}, ${activeSession?.id ?? null}, now(), ${lat}, ${lon}, ${accuracyM})
    `

    const visibleFriends = await LocationService.getVisibleFriendsFor(userId)
    // Push the user's updated location to each friend who can see them
    for (const viewer of visibleFriends as any[]) {
      const event = LocationService.buildLocationEvent(userId, viewer, lat, lon, approx, activeSession?.id)
      WSServer.sendToUser(viewer.viewer_id, event)
    }
  }

  static async getVisibleFriendsFor(viewerId: string): Promise<unknown[]> {
    return db`
      SELECT
        u.id AS friend_id,
        llp.latitude,
        llp.longitude,
        llp.rough_area_latitude,
        llp.rough_area_longitude,
        llp.last_seen_at,
        llp.presence_state,
        llp.session_id,
        COALESCE(lvr.visibility, ps.location_precision) AS effective_visibility
      FROM friendships f
      JOIN users u ON (
        CASE WHEN f.user_a_id = ${viewerId} THEN f.user_b_id ELSE f.user_a_id END = u.id
      )
      JOIN privacy_settings ps ON ps.user_id = u.id
      LEFT JOIN live_location_presence llp ON llp.user_id = u.id
      LEFT JOIN location_visibility_rules lvr
        ON lvr.owner_user_id = u.id
        AND lvr.viewer_user_id = ${viewerId}
        AND (lvr.expires_at IS NULL OR lvr.expires_at > now())
      WHERE (f.user_a_id = ${viewerId} OR f.user_b_id = ${viewerId})
        AND f.status = 'active'
        AND ps.location_sharing_enabled = true
        AND ps.panic_privacy_active = false
        AND llp.presence_state != 'hidden'
    `
  }

  static async getFriendPresencesFor(viewerId: string): Promise<unknown[]> {
    const rows = await db`
      SELECT
        u.id AS friend_id,
        u.display_name,
        up.profile_image_url,
        up.join_status_default,
        llp.latitude,
        llp.longitude,
        llp.rough_area_latitude,
        llp.rough_area_longitude,
        llp.last_seen_at,
        llp.presence_state,
        llp.session_id,
        llp.venue_name_snapshot,
        COALESCE(lvr.visibility, ps.location_precision) AS effective_visibility,
        ps.drunkness_visibility,
        ps.panic_privacy_active
      FROM friendships f
      JOIN users u ON (
        CASE WHEN f.user_a_id = ${viewerId} THEN f.user_b_id ELSE f.user_a_id END = u.id
      )
      JOIN user_profiles up ON up.user_id = u.id
      JOIN privacy_settings ps ON ps.user_id = u.id
      LEFT JOIN live_location_presence llp ON llp.user_id = u.id
      LEFT JOIN location_visibility_rules lvr
        ON lvr.owner_user_id = u.id
        AND lvr.viewer_user_id = ${viewerId}
        AND (lvr.expires_at IS NULL OR lvr.expires_at > now())
      WHERE (f.user_a_id = ${viewerId} OR f.user_b_id = ${viewerId})
        AND f.status = 'active'
    `

    return (rows as any[]).map((row) => {
      if (row.panic_privacy_active) {
        return { userId: row.friend_id, displayName: row.display_name, visibility: 'hidden', presenceState: 'hidden' }
      }

      const visibility = row.effective_visibility ?? 'hidden'
      const base = {
        userId: row.friend_id,
        displayName: row.display_name,
        profileImageUrl: row.profile_image_url,
        joinStatus: row.join_status_default,
        presenceState: row.presence_state ?? 'location_off',
        lastSeenAt: row.last_seen_at,
        sessionId: row.session_id,
        visibility,
      }

      if (visibility === 'exact') {
        return { ...base, lat: row.latitude, lon: row.longitude }
      }
      if (visibility === 'rough_area') {
        return { ...base, roughAreaLat: row.rough_area_latitude, roughAreaLon: row.rough_area_longitude }
      }
      return base
    })
  }

  static applyApproximation(lat: number, lon: number): { lat: number; lon: number } {
    return {
      lat: Math.round(lat * 1000) / 1000,
      lon: Math.round(lon * 1000) / 1000,
    }
  }

  private static buildLocationEvent(
    userId: string,
    viewer: any,
    lat: number,
    lon: number,
    approx: { lat: number; lon: number },
    sessionId?: string
  ) {
    const visibility = viewer.effective_visibility ?? 'hidden'
    const base = {
      type: 'location_update' as const,
      userId,
      visibility,
      lastSeenAt: new Date().toISOString(),
      sessionId,
    }

    if (visibility === 'exact') return { ...base, lat, lon }
    if (visibility === 'rough_area') return { ...base, roughAreaLat: approx.lat, roughAreaLon: approx.lon }
    return base
  }
}
