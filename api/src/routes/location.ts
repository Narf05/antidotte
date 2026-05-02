import type { FastifyPluginAsync } from 'fastify'
import { requireAuth } from '../middleware/auth'
import { LocationService } from '../services/LocationService'
import { db } from '../db/client'

const locationRoutes: FastifyPluginAsync = async (app) => {
  app.addHook('preHandler', requireAuth)

  app.post('/presence', async (req, reply) => {
    const userId = (req as any).userId
    const { lat, lon, accuracyM } = req.body as any
    if (lat === undefined || lon === undefined) {
      return reply.status(400).send({ error: 'lat and lon are required' })
    }
    await LocationService.updatePresence(userId, lat, lon, accuracyM ?? 0)
    return reply.status(204).send()
  })

  app.get('/friends', async (req, reply) => {
    const userId = (req as any).userId
    const presences = await LocationService.getFriendPresencesFor(userId)
    return reply.send(presences)
  })

  app.get('/visibility-rules', async (req, reply) => {
    const userId = (req as any).userId
    const rules = await db`
      SELECT * FROM location_visibility_rules
      WHERE owner_user_id = ${userId}
      ORDER BY created_at DESC
    `
    return reply.send(rules)
  })

  app.post('/visibility-rules', async (req, reply) => {
    const userId = (req as any).userId
    const { viewerUserId, viewerGroupId, visibility, activeOnlyDuringSession, expiresAt } = req.body as any

    if (!viewerUserId && !viewerGroupId) {
      return reply.status(400).send({ error: 'viewerUserId or viewerGroupId is required' })
    }

    const [rule] = await db`
      INSERT INTO location_visibility_rules
        (owner_user_id, viewer_user_id, viewer_group_id, visibility, active_only_during_session, expires_at)
      VALUES
        (${userId}, ${viewerUserId ?? null}, ${viewerGroupId ?? null},
         ${visibility ?? 'exact'}, ${activeOnlyDuringSession ?? false}, ${expiresAt ?? null})
      ON CONFLICT DO NOTHING
      RETURNING id
    `
    return reply.status(201).send({ ruleId: rule?.id })
  })

  app.delete<{ Params: { ruleId: string } }>('/visibility-rules/:ruleId', async (req, reply) => {
    const userId = (req as any).userId
    await db`
      DELETE FROM location_visibility_rules
      WHERE id = ${req.params.ruleId} AND owner_user_id = ${userId}
    `
    return reply.status(204).send()
  })
}

export default locationRoutes
