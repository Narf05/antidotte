import { db } from '../db/client'

export class PrivacyService {
  static async checkConsent(userId: string, consentType: string): Promise<boolean> {
    // TODO: query privacy_settings for the relevant toggle
    return false
  }

  static async recordConsent(userId: string, consentType: string, status: string, source: string, policyVersion: string): Promise<void> {
    // TODO: insert privacy_consents row
  }

  static async auditEvent(userId: string, eventType: string, detail?: Record<string, unknown>): Promise<void> {
    // TODO: insert privacy_audit_events row
  }

  static async activatePanicPrivacy(userId: string): Promise<void> {
    // TODO: set panic_privacy_active = true, expires_at = now + 24h
    //       push hidden location and score to all friends via WebSocket immediately
  }
}
