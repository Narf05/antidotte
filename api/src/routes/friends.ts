import type { FastifyPluginAsync } from 'fastify'
import { requireAuth } from '../middleware/auth'
import { FriendService } from '../services/FriendService'
import { NotificationService } from '../services/NotificationService'

const friendRoutes: FastifyPluginAsync = async (app) => {
  app.addHook('preHandler', requireAuth)

  app.get('/', async (req, reply) => {
    const userId = (req as any).userId
    const friends = await FriendService.listFriends(userId)
    return reply.send(friends)
  })

  app.post('/request', async (req, reply) => {
    const userId = (req as any).userId
    const { recipientId, inviteCode, source } = req.body as any

    let targetId = recipientId

    if (inviteCode) {
      const ownerId = await FriendService.redeemInviteCode(inviteCode, userId)
      if (!ownerId) return reply.status(404).send({ error: 'invalid or expired invite code' })
      targetId = ownerId
    }

    if (!targetId) return reply.status(400).send({ error: 'recipientId or inviteCode is required' })
    if (targetId === userId) return reply.status(400).send({ error: 'cannot send request to yourself' })

    await FriendService.sendRequest(userId, targetId, source ?? 'search')
    await NotificationService.send(targetId, 'friend_request', undefined, userId)

    return reply.status(201).send()
  })

  app.patch<{ Params: { requestId: string } }>('/request/:requestId', async (req, reply) => {
    const userId = (req as any).userId
    const { requestId } = req.params
    const { action } = req.body as any

    if (action === 'accept') {
      await FriendService.acceptRequest(requestId, userId)
      return reply.status(204).send()
    }
    if (action === 'decline') {
      await FriendService.declineRequest(requestId, userId)
      return reply.status(204).send()
    }
    return reply.status(400).send({ error: 'action must be accept or decline' })
  })

  app.delete<{ Params: { friendId: string } }>('/:friendId', async (req, reply) => {
    const userId = (req as any).userId
    await FriendService.removeFriend(userId, req.params.friendId)
    return reply.status(204).send()
  })

  app.post<{ Params: { userId: string } }>('/block/:userId', async (req, reply) => {
    const userId = (req as any).userId
    await FriendService.blockUser(userId, req.params.userId)
    return reply.status(204).send()
  })

  app.post('/invite-code', async (req, reply) => {
    const userId = (req as any).userId
    const code = await FriendService.generateInviteCode(userId)
    return reply.send({ code })
  })
}

export default friendRoutes
