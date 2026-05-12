import type { FastifyPluginAsync } from 'fastify'
import { requireAuth } from '../middleware/auth'
import { DrunkScoreService } from '../services/DrunkScoreService'
import { db } from '../db/client'

const scoreRoutes: FastifyPluginAsync = async (app) => {
  app.addHook('preHandler', requireAuth)

  app.get('/current', async (req, reply) => {
    const userId = (req as any).userId
    const [snapshot] = await db`
      SELECT * FROM drunk_score_snapshots
      WHERE user_id = ${userId}
      ORDER BY created_at DESC
      LIMIT 1
    `
    return reply.send(snapshot ?? { percentage: 0, confidence: 0, tipsinessCategory: 'unknown' })
  })

  app.get('/history', async (req, reply) => {
    const userId = (req as any).userId
    const { from, to, sessionId } = req.query as any

    let snapshots
    if (sessionId) {
      snapshots = await db`
        SELECT * FROM drunk_score_snapshots
        WHERE user_id = ${userId} AND session_id = ${sessionId}
        ORDER BY created_at ASC
      `
    } else {
      const fromDate = from ?? new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString()
      const toDate = to ?? new Date().toISOString()
      snapshots = await db`
        SELECT * FROM drunk_score_snapshots
        WHERE user_id = ${userId}
          AND created_at >= ${fromDate}
          AND created_at <= ${toDate}
        ORDER BY created_at ASC
      `
    }
    return reply.send(snapshots)
  })

  app.post('/active-test', async (req, reply) => {
    const userId = (req as any).userId
    const { gameType, rawScore, normalizedScore, confidence, roundType, sessionId, isGuest, guestLabel } =
      req.body as any

    if (!gameType || rawScore === undefined || normalizedScore === undefined) {
      return reply.status(400).send({ error: 'gameType, rawScore, and normalizedScore are required' })
    }

    await db`
      INSERT INTO active_test_results
        (user_id, session_id, game_type, raw_score, normalized_score, confidence, round_type, is_guest, guest_label)
      VALUES
        (${userId}, ${sessionId ?? null}, ${gameType}, ${rawScore}, ${normalizedScore},
         ${confidence ?? 1.0}, ${roundType ?? 'quick'}, ${isGuest ?? false}, ${guestLabel ?? null})
    `

    await DrunkScoreService.recompute(userId, sessionId)

    const [snapshot] = await db`
      SELECT * FROM drunk_score_snapshots
      WHERE user_id = ${userId}
      ORDER BY created_at DESC
      LIMIT 1
    `
    return reply.send(snapshot)
  })
}

export default scoreRoutes
