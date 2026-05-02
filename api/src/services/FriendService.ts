import { db } from '../db/client'
import crypto from 'crypto'

export class FriendService {
  static async sendRequest(requesterId: string, recipientId: string, source: string): Promise<void> {
    await db`
      INSERT INTO friend_requests (requester_user_id, recipient_user_id, source)
      VALUES (${requesterId}, ${recipientId}, ${source})
    `
  }

  static async acceptRequest(requestId: string, userId: string): Promise<void> {
    const [request] = await db`
      UPDATE friend_requests
      SET status = 'accepted', responded_at = now()
      WHERE id = ${requestId} AND recipient_user_id = ${userId} AND status = 'pending'
      RETURNING requester_user_id, recipient_user_id
    `
    if (!request) return

    const [a, b] = [request.requester_user_id, request.recipient_user_id].sort()
    await db`
      INSERT INTO friendships (user_a_id, user_b_id)
      VALUES (${a}, ${b})
      ON CONFLICT (user_a_id, user_b_id) DO UPDATE SET status = 'active', updated_at = now()
    `
  }

  static async declineRequest(requestId: string, userId: string): Promise<void> {
    await db`
      UPDATE friend_requests
      SET status = 'declined', responded_at = now()
      WHERE id = ${requestId} AND recipient_user_id = ${userId} AND status = 'pending'
    `
  }

  static async removeFriend(userId: string, friendId: string): Promise<void> {
    const [a, b] = [userId, friendId].sort()
    await db`
      UPDATE friendships
      SET status = 'removed', updated_at = now()
      WHERE user_a_id = ${a} AND user_b_id = ${b}
    `
  }

  static async blockUser(blockerId: string, blockedId: string): Promise<void> {
    await db`
      INSERT INTO user_blocks (blocker_user_id, blocked_user_id)
      VALUES (${blockerId}, ${blockedId})
      ON CONFLICT DO NOTHING
    `
    const [a, b] = [blockerId, blockedId].sort()
    await db`
      UPDATE friendships
      SET status = 'blocked', updated_at = now()
      WHERE user_a_id = ${a} AND user_b_id = ${b}
    `
  }

  static async generateInviteCode(userId: string): Promise<string> {
    const raw = crypto.randomBytes(6).toString('base64url')
    const hash = crypto.createHash('sha256').update(raw).digest('hex')
    const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000)

    await db`
      INSERT INTO friend_invite_codes (user_id, code_hash, expires_at)
      VALUES (${userId}, ${hash}, ${expiresAt})
    `

    return raw
  }

  static async redeemInviteCode(code: string, redeemerId: string): Promise<string | null> {
    const hash = crypto.createHash('sha256').update(code).digest('hex')

    const [invite] = await db`
      SELECT user_id FROM friend_invite_codes
      WHERE code_hash = ${hash}
        AND revoked_at IS NULL
        AND (expires_at IS NULL OR expires_at > now())
      LIMIT 1
    `
    if (!invite) return null
    return invite.user_id
  }

  static async listFriends(userId: string): Promise<unknown[]> {
    return db`
      SELECT
        u.id, u.username, u.display_name,
        up.profile_image_url, up.join_status_default
      FROM friendships f
      JOIN users u ON (
        CASE WHEN f.user_a_id = ${userId} THEN f.user_b_id ELSE f.user_a_id END = u.id
      )
      JOIN user_profiles up ON up.user_id = u.id
      WHERE (f.user_a_id = ${userId} OR f.user_b_id = ${userId})
        AND f.status = 'active'
    `
  }
}
