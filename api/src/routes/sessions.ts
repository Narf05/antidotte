import type { FastifyPluginAsync } from 'fastify'
import { requireAuth } from '../middleware/auth'
import { SessionService } from '../services/SessionService'

const sessionRoutes: FastifyPluginAsync = async (app) => {
  app.addHook('preHandler', requireAuth)

  app.get('/', async (req, reply) => {
    const userId = (req as any).userId
    const { limit, offset } = req.query as any
    const sessions = await SessionService.listSessions(userId, Number(limit) || 20, Number(offset) || 0)
    return reply.send(sessions)
  })

  app.post('/', async (req, reply) => {
    const userId = (req as any).userId
    const { title, theme } = req.body as any
    if (!title) return reply.status(400).send({ error: 'title is required' })
    const sessionId = await SessionService.startSession(userId, title, theme)
    return reply.status(201).send({ sessionId })
  })

  app.get<{ Params: { sessionId: string } }>('/:sessionId', async (req, reply) => {
    const userId = (req as any).userId
    const session = await SessionService.getSession(req.params.sessionId, userId)
    if (!session) return reply.status(404).send({ error: 'session not found' })
    return reply.send(session)
  })

  app.patch<{ Params: { sessionId: string } }>('/:sessionId', async (req, reply) => {
    const userId = (req as any).userId
    const { title, theme, privacyScope } = req.body as any
    await SessionService.updateSession(req.params.sessionId, userId, { title, theme, privacyScope })
    return reply.status(204).send()
  })

  app.post<{ Params: { sessionId: string } }>('/:sessionId/end', async (req, reply) => {
    const userId = (req as any).userId
    await SessionService.endSession(req.params.sessionId, userId)
    return reply.status(204).send()
  })

  app.delete<{ Params: { sessionId: string } }>('/:sessionId', async (req, reply) => {
    const userId = (req as any).userId
    await SessionService.deleteSession(req.params.sessionId, userId)
    return reply.status(204).send()
  })
}

export default sessionRoutes
