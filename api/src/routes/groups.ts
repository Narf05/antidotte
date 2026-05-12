import type { FastifyPluginAsync } from 'fastify'
import { requireAuth } from '../middleware/auth'
import { db } from '../db/client'

const groupRoutes: FastifyPluginAsync = async (app) => {
  app.addHook('preHandler', requireAuth)

  app.get('/', async (req, reply) => {
    const userId = (req as any).userId
    const groups = await db`
      SELECT g.*, gm.role
      FROM groups g
      JOIN group_members gm ON gm.group_id = g.id AND gm.user_id = ${userId} AND gm.status = 'active'
      ORDER BY g.created_at DESC
    `
    return reply.send(groups)
  })

  app.post('/', async (req, reply) => {
    const userId = (req as any).userId
    const { name, description, visibility } = req.body as any
    if (!name) return reply.status(400).send({ error: 'name is required' })

    const [group] = await db`
      INSERT INTO groups (owner_user_id, name, description, visibility)
      VALUES (${userId}, ${name}, ${description ?? null}, ${visibility ?? 'private'})
      RETURNING id
    `
    await db`
      INSERT INTO group_members (group_id, user_id, role, status, joined_at)
      VALUES (${group.id}, ${userId}, 'owner', 'active', now())
    `
    return reply.status(201).send({ groupId: group.id })
  })

  app.patch<{ Params: { groupId: string } }>('/:groupId', async (req, reply) => {
    const userId = (req as any).userId
    const { name, description, visibility } = req.body as any
    await db`
      UPDATE groups SET
        name = COALESCE(${name ?? null}, name),
        description = COALESCE(${description ?? null}, description),
        visibility = COALESCE(${visibility ?? null}, visibility),
        updated_at = now()
      WHERE id = ${req.params.groupId} AND owner_user_id = ${userId}
    `
    return reply.status(204).send()
  })

  app.delete<{ Params: { groupId: string } }>('/:groupId', async (req, reply) => {
    const userId = (req as any).userId
    await db`DELETE FROM groups WHERE id = ${req.params.groupId} AND owner_user_id = ${userId}`
    return reply.status(204).send()
  })

  app.post<{ Params: { groupId: string } }>('/:groupId/members', async (req, reply) => {
    const userId = (req as any).userId
    const { memberId } = req.body as any
    if (!memberId) return reply.status(400).send({ error: 'memberId is required' })

    const [group] = await db`SELECT id FROM groups WHERE id = ${req.params.groupId} AND owner_user_id = ${userId}`
    if (!group) return reply.status(403).send({ error: 'not group owner' })

    await db`
      INSERT INTO group_members (group_id, user_id, role, status, joined_at)
      VALUES (${req.params.groupId}, ${memberId}, 'member', 'active', now())
      ON CONFLICT (group_id, user_id) DO UPDATE SET status = 'active', joined_at = now()
    `
    return reply.status(201).send()
  })

  app.delete<{ Params: { groupId: string; userId: string } }>('/:groupId/members/:userId', async (req, reply) => {
    const callerId = (req as any).userId
    const { groupId, userId: memberId } = req.params

    const [group] = await db`SELECT owner_user_id FROM groups WHERE id = ${groupId}`
    if (!group) return reply.status(404).send({ error: 'group not found' })
    if (group.owner_user_id !== callerId && memberId !== callerId) {
      return reply.status(403).send({ error: 'forbidden' })
    }

    await db`
      UPDATE group_members SET status = 'removed'
      WHERE group_id = ${groupId} AND user_id = ${memberId}
    `
    return reply.status(204).send()
  })
}

export default groupRoutes
