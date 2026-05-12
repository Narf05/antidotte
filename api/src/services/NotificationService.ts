import { db } from '../db/client'
import { config } from '../config'
import https from 'https'
import fs from 'fs'
import crypto from 'crypto'

export class NotificationService {
  static async send(
    recipientId: string,
    type: string,
    relatedId?: string,
    actorId?: string
  ): Promise<void> {
    await db`
      INSERT INTO social_notifications (recipient_user_id, actor_user_id, type, related_id)
      VALUES (${recipientId}, ${actorId ?? null}, ${type}, ${relatedId ?? null})
    `

    const [user] = await db`
      SELECT device_token FROM users WHERE id = ${recipientId}
    `.catch(() => [null])

    if (!user?.device_token) return

    const body = NotificationService.notificationBody(type, actorId)
    if (!body) return

    await NotificationService.sendAPNs(user.device_token, {
      aps: { alert: body, sound: 'default', badge: 1 },
      type,
      relatedId,
    })
  }

  static async sendAPNs(deviceToken: string, payload: Record<string, unknown>): Promise<void> {
    if (!config.apnsKeyPath || !config.apnsKeyId || !config.apnsTeamId) return

    const keyData = fs.readFileSync(config.apnsKeyPath, 'utf8')
    const now = Math.floor(Date.now() / 1000)

    const header = Buffer.from(JSON.stringify({ alg: 'ES256', kid: config.apnsKeyId })).toString('base64url')
    const claims = Buffer.from(JSON.stringify({ iss: config.apnsTeamId, iat: now })).toString('base64url')
    const signingInput = `${header}.${claims}`

    const sign = crypto.createSign('SHA256')
    sign.update(signingInput)
    const sig = sign.sign({ key: keyData, dsaEncoding: 'ieee-p1363' }).toString('base64url')
    const jwtToken = `${signingInput}.${sig}`

    const body = JSON.stringify(payload)
    const options: https.RequestOptions = {
      hostname: 'api.push.apple.com',
      port: 443,
      path: `/3/device/${deviceToken}`,
      method: 'POST',
      headers: {
        authorization: `bearer ${jwtToken}`,
        'apns-topic': config.apnsBundleId,
        'content-type': 'application/json',
        'content-length': Buffer.byteLength(body),
      },
    }

    await new Promise<void>((resolve, reject) => {
      const req = https.request(options, (res) => {
        res.resume()
        res.on('end', resolve)
      })
      req.on('error', reject)
      req.write(body)
      req.end()
    })
  }

  private static notificationBody(type: string, _actorId?: string): string | null {
    switch (type) {
      case 'friend_request': return 'You have a new friend request'
      case 'friend_accepted': return 'Your friend request was accepted'
      case 'session_started': return 'A friend started a night out'
      case 'nearby_friend': return 'A friend is nearby'
      case 'starts_refreshing': return 'A friend started their first drink'
      default: return null
    }
  }
}
