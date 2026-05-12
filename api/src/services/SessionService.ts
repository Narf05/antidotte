import { db } from '../db/client'
import { DrunkScoreService } from './DrunkScoreService'
import { WSServer } from '../websocket/WSServer'

export class SessionService {
  static async startSession(userId: string, title: string, theme?: string): Promise<string> {
    const autoEndAt = new Date(Date.now() + 4 * 60 * 60 * 1000)

    const [session] = await db`
      INSERT INTO night_out_sessions (user_id, title, theme, started_at, auto_end_at)
      VALUES (${userId}, ${title}, ${theme ?? null}, now(), ${autoEndAt.toISOString()})
      RETURNING id
    `

    await DrunkScoreService.applySessionFloor(userId, session.id)

    const friends = await db`
      SELECT
        CASE WHEN f.user_a_id = ${userId} THEN f.user_b_id ELSE f.user_a_id END AS friend_id
      FROM friendships f
      WHERE (f.user_a_id = ${userId} OR f.user_b_id = ${userId}) AND f.status = 'active'
    `

    WSServer.broadcast(
      (friends as any[]).map((f: any) => f.friend_id),
      { type: 'session_started', userId, sessionId: session.id, sessionTitle: title }
    )

    return session.id
  }

  static async endSession(sessionId: string, userId: string): Promise<void> {
    await db`
      UPDATE night_out_sessions
      SET ended_at = now(), is_active = false, updated_at = now()
      WHERE id = ${sessionId} AND user_id = ${userId}
    `

    const friends = await db`
      SELECT
        CASE WHEN f.user_a_id = ${userId} THEN f.user_b_id ELSE f.user_a_id END AS friend_id
      FROM friendships f
      WHERE (f.user_a_id = ${userId} OR f.user_b_id = ${userId}) AND f.status = 'active'
    `

    WSServer.broadcast(
      (friends as any[]).map((f: any) => f.friend_id),
      { type: 'session_ended', userId, sessionId }
    )
  }

  static async autoEndIfInactive(sessionId: string): Promise<void> {
    const [session] = await db`
      SELECT user_id FROM night_out_sessions
      WHERE id = ${sessionId} AND is_active = true AND auto_end_at < now()
      LIMIT 1
    `
    if (!session) return

    await SessionService.endSession(sessionId, session.user_id)
  }

  static async getSession(sessionId: string, userId: string): Promise<unknown> {
    const [session] = await db`
      SELECT * FROM night_out_sessions
      WHERE id = ${sessionId} AND user_id = ${userId}
    `
    return session
  }

  static async listSessions(userId: string, limit = 20, offset = 0): Promise<unknown[]> {
    return db`
      SELECT * FROM night_out_sessions
      WHERE user_id = ${userId}
      ORDER BY started_at DESC
      LIMIT ${limit} OFFSET ${offset}
    `
  }

  static async updateSession(sessionId: string, userId: string, data: {
    title?: string
    theme?: string
    privacyScope?: string
  }): Promise<void> {
    await db`
      UPDATE night_out_sessions SET
        title = COALESCE(${data.title ?? null}, title),
        theme = COALESCE(${data.theme ?? null}, theme),
        privacy_scope = COALESCE(${data.privacyScope ?? null}, privacy_scope),
        updated_at = now()
      WHERE id = ${sessionId} AND user_id = ${userId}
    `
  }

  static async deleteSession(sessionId: string, userId: string): Promise<void> {
    // Soft-delete: mark as inactive, do not hard-delete for data integrity
    await db`
      UPDATE night_out_sessions
      SET is_active = false, ended_at = COALESCE(ended_at, now()), updated_at = now()
      WHERE id = ${sessionId} AND user_id = ${userId}
    `
    await db`UPDATE drink_logs SET is_deleted = true WHERE session_id = ${sessionId} AND user_id = ${userId}`
  }
}
