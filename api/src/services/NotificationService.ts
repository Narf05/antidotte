import { db } from '../db/client'

export class NotificationService {
  static async send(recipientId: string, type: string, relatedId?: string, actorId?: string): Promise<void> {
    // TODO: insert social_notifications row, send APNs push
    // Do not reveal exact location or drunkness in notification text
  }

  static async sendAPNs(deviceToken: string, payload: Record<string, unknown>): Promise<void> {
    // TODO: HTTP/2 request to Apple APNs
  }
}
