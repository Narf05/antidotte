import type { FastifyPluginAsync } from 'fastify'
import { requireAuth } from '../middleware/auth'
import { db } from '../db/client'

const notificationRoutes: FastifyPluginAsync = async (app) => {
  app.addHook('preHandler', requireAuth)

  app.get('/', async (req, reply) => {
    const userId = (req as any).userId
    const { limit, offset } = req.query as any
    const notifications = await db`
      SELECT
        sn.*,
        u.username AS actor_username,
        u.display_name AS actor_display_name,
        up.profile_image_url AS actor_profile_image_url
      FROM social_notifications sn
      LEFT JOIN users u ON u.id = sn.actor_user_id
      LEFT JOIN user_profiles up ON up.user_id = u.id
      WHERE sn.recipient_user_id = ${userId}
      ORDER BY sn.created_at DESC
      LIMIT ${Number(limit) || 30} OFFSET ${Number(offset) || 0}
    `
    return reply.send(notifications)
  })

  app.patch<{ Params: { id: string } }>('/:id/read', async (req, reply) => {
    const userId = (req as any).userId
    await db`
      UPDATE social_notifications
      SET read_at = now()
      WHERE id = ${req.params.id} AND recipient_user_id = ${userId}
    `
    return reply.status(204).send()
  })
}

export default notificationRoutes
