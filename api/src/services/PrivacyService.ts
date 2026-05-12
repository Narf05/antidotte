import { db } from '../db/client'
import { WSServer } from '../websocket/WSServer'

const CONSENT_COLUMN_MAP: Record<string, string> = {
  location_sharing: 'location_sharing_enabled',
  motion_tracking: 'motion_tracking_enabled',
  phone_usage_tracking: 'phone_usage_tracking_enabled',
  voice_analysis: 'voice_analysis_enabled',
  message_analysis: 'message_analysis_enabled',
  photo_drink_detection: 'photo_drink_detection_enabled',
}

export class PrivacyService {
  static async checkConsent(userId: string, consentType: string): Promise<boolean> {
    const column = CONSENT_COLUMN_MAP[consentType]
    if (!column) return false

    const [row] = await db`
      SELECT ${db.unsafe(column)} AS enabled
      FROM privacy_settings WHERE user_id = ${userId}
    `
    return row?.enabled === true
  }

  static async recordConsent(
    userId: string,
    consentType: string,
    status: string,
    source: string,
    policyVersion: string
  ): Promise<void> {
    await db`
      INSERT INTO privacy_consents (user_id, consent_type, status, source, policy_version)
      VALUES (${userId}, ${consentType}, ${status}, ${source}, ${policyVersion})
    `
  }

  static async auditEvent(
    userId: string,
    eventType: string,
    detail?: Record<string, unknown>
  ): Promise<void> {
    await db`
      INSERT INTO privacy_audit_events (user_id, event_type, detail)
      VALUES (${userId}, ${eventType}, ${detail ? JSON.stringify(detail) : null})
    `
  }

  static async activatePanicPrivacy(userId: string): Promise<void> {
    const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000)

    await db`
      UPDATE privacy_settings
      SET panic_privacy_active = true, panic_privacy_expires_at = ${expiresAt.toISOString()}, updated_at = now()
      WHERE user_id = ${userId}
    `

    await PrivacyService.auditEvent(userId, 'panic_privacy_activated')

    const friends = await db`
      SELECT
        CASE WHEN f.user_a_id = ${userId} THEN f.user_b_id ELSE f.user_a_id END AS friend_id
      FROM friendships f
      WHERE (f.user_a_id = ${userId} OR f.user_b_id = ${userId}) AND f.status = 'active'
    `

    WSServer.broadcast(
      (friends as any[]).map((f: any) => f.friend_id),
      {
        type: 'location_update',
        userId,
        visibility: 'hidden',
        lastSeenAt: new Date().toISOString(),
      }
    )
  }

  static async deactivatePanicPrivacy(userId: string): Promise<void> {
    await db`
      UPDATE privacy_settings
      SET panic_privacy_active = false, panic_privacy_expires_at = NULL, updated_at = now()
      WHERE user_id = ${userId}
    `
    await PrivacyService.auditEvent(userId, 'panic_privacy_deactivated')
  }
}
