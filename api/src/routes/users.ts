import type { FastifyPluginAsync } from 'fastify'
import { requireAuth } from '../middleware/auth'
import { db } from '../db/client'

const userRoutes: FastifyPluginAsync = async (app) => {
  app.addHook('preHandler', requireAuth)

  app.get('/me', async (req, reply) => {
    const userId = (req as any).userId
    const [user] = await db`
      SELECT
        u.id, u.username, u.display_name, u.created_at,
        up.profile_image_url, up.language, up.style_mode, up.join_status_default,
        ps.location_sharing_enabled, ps.location_precision, ps.drunkness_visibility,
        ps.motion_tracking_enabled, ps.phone_usage_tracking_enabled,
        ps.photo_drink_detection_enabled, ps.notifications_enabled,
        ps.panic_privacy_active
      FROM users u
      JOIN user_profiles up ON up.user_id = u.id
      JOIN privacy_settings ps ON ps.user_id = u.id
      WHERE u.id = ${userId}
    `
    if (!user) return reply.status(404).send({ error: 'user not found' })
    return reply.send(user)
  })

  app.patch('/me', async (req, reply) => {
    const userId = (req as any).userId
    const { displayName, username, profileImageUrl } = req.body as any

    if (displayName !== undefined || username !== undefined) {
      await db`
        UPDATE users SET
          display_name = COALESCE(${displayName ?? null}, display_name),
          username = COALESCE(${username ?? null}, username),
          updated_at = now()
        WHERE id = ${userId}
      `
    }
    if (profileImageUrl !== undefined) {
      await db`UPDATE user_profiles SET profile_image_url = ${profileImageUrl} WHERE user_id = ${userId}`
    }
    return reply.status(204).send()
  })

  app.get('/me/calibration', async (req, reply) => {
    const userId = (req as any).userId
    const [cal] = await db`SELECT * FROM user_calibration WHERE user_id = ${userId}`
    return reply.send(cal ?? {})
  })

  app.patch('/me/calibration', async (req, reply) => {
    const userId = (req as any).userId
    const {
      bodyWeightKg, heightCm, usualDrinksPerSession,
      usualSessionsPerWeek, toleranceSelfRating, sports, drinkUnitDefinition,
    } = req.body as any

    await db`
      UPDATE user_calibration SET
        body_weight_kg = COALESCE(${bodyWeightKg ?? null}, body_weight_kg),
        height_cm = COALESCE(${heightCm ?? null}, height_cm),
        usual_drinks_per_session = COALESCE(${usualDrinksPerSession ?? null}, usual_drinks_per_session),
        usual_sessions_per_week = COALESCE(${usualSessionsPerWeek ?? null}, usual_sessions_per_week),
        tolerance_self_rating = COALESCE(${toleranceSelfRating ?? null}, tolerance_self_rating),
        sports = COALESCE(${sports ?? null}, sports),
        drink_unit_definition = COALESCE(${drinkUnitDefinition ? JSON.stringify(drinkUnitDefinition) : null}::jsonb, drink_unit_definition),
        updated_at = now()
      WHERE user_id = ${userId}
    `
    return reply.status(204).send()
  })

  app.get('/me/settings', async (req, reply) => {
    const userId = (req as any).userId
    const [settings] = await db`SELECT * FROM privacy_settings WHERE user_id = ${userId}`
    return reply.send(settings ?? {})
  })

  app.patch('/me/settings', async (req, reply) => {
    const userId = (req as any).userId
    const {
      locationSharingEnabled, locationPrecision, shareWhenAppClosed,
      showMeOnFriendMap, shareDuringSessionsOnly, photoDetectionEnabled,
      savePhotosEnabled, motionTrackingEnabled, phoneUsageTrackingEnabled,
      voiceAnalysisEnabled, drunknessVisibility, notificationsEnabled,
      panicPrivacyActive, styleMode, joinStatusDefault,
    } = req.body as any

    await db`
      UPDATE privacy_settings SET
        location_sharing_enabled = COALESCE(${locationSharingEnabled ?? null}, location_sharing_enabled),
        location_precision = COALESCE(${locationPrecision ?? null}, location_precision),
        share_when_app_closed = COALESCE(${shareWhenAppClosed ?? null}, share_when_app_closed),
        show_me_on_friend_map = COALESCE(${showMeOnFriendMap ?? null}, show_me_on_friend_map),
        share_during_sessions_only = COALESCE(${shareDuringSessionsOnly ?? null}, share_during_sessions_only),
        photo_drink_detection_enabled = COALESCE(${photoDetectionEnabled ?? null}, photo_drink_detection_enabled),
        save_drink_photos_enabled = COALESCE(${savePhotosEnabled ?? null}, save_drink_photos_enabled),
        motion_tracking_enabled = COALESCE(${motionTrackingEnabled ?? null}, motion_tracking_enabled),
        phone_usage_tracking_enabled = COALESCE(${phoneUsageTrackingEnabled ?? null}, phone_usage_tracking_enabled),
        voice_analysis_enabled = COALESCE(${voiceAnalysisEnabled ?? null}, voice_analysis_enabled),
        drunkness_visibility = COALESCE(${drunknessVisibility ?? null}, drunkness_visibility),
        notifications_enabled = COALESCE(${notificationsEnabled ?? null}, notifications_enabled),
        panic_privacy_active = COALESCE(${panicPrivacyActive ?? null}, panic_privacy_active),
        updated_at = now()
      WHERE user_id = ${userId}
    `

    if (styleMode !== undefined || joinStatusDefault !== undefined) {
      await db`
        UPDATE user_profiles SET
          style_mode = COALESCE(${styleMode ?? null}, style_mode),
          join_status_default = COALESCE(${joinStatusDefault ?? null}, join_status_default),
          updated_at = now()
        WHERE user_id = ${userId}
      `
    }

    if (panicPrivacyActive === true) {
      const { PrivacyService } = await import('../services/PrivacyService')
      await PrivacyService.activatePanicPrivacy(userId)
    } else if (panicPrivacyActive === false) {
      const { PrivacyService } = await import('../services/PrivacyService')
      await PrivacyService.deactivatePanicPrivacy(userId)
    }

    return reply.status(204).send()
  })

  app.get<{ Querystring: { q?: string } }>('/search', async (req, reply) => {
    const userId = (req as any).userId
    const q = req.query.q?.trim()
    if (!q || q.length < 2) return reply.status(400).send({ error: 'q must be at least 2 characters' })

    const results = await db`
      SELECT u.id, u.username, u.display_name, up.profile_image_url
      FROM users u
      JOIN user_profiles up ON up.user_id = u.id
      LEFT JOIN user_blocks bl
        ON (bl.blocker_user_id = ${userId} AND bl.blocked_user_id = u.id)
        OR (bl.blocker_user_id = u.id AND bl.blocked_user_id = ${userId})
      WHERE u.username ILIKE ${'%' + q + '%'}
        AND u.id != ${userId}
        AND bl.blocker_user_id IS NULL
      LIMIT 20
    `
    return reply.send(results)
  })
}

export default userRoutes
