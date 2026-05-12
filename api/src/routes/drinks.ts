import type { FastifyPluginAsync } from 'fastify'
import { requireAuth } from '../middleware/auth'
import { DrinkService } from '../services/DrinkService'

const drinkRoutes: FastifyPluginAsync = async (app) => {
  app.addHook('preHandler', requireAuth)

  app.get('/', async (req, reply) => {
    const userId = (req as any).userId
    const { sessionId, limit, offset } = req.query as any
    const logs = await DrinkService.listDrinks(userId, sessionId, Number(limit) || 50, Number(offset) || 0)
    return reply.send(logs)
  })

  app.post('/', async (req, reply) => {
    const userId = (req as any).userId
    const body = req.body as any
    if (!body.drinkType) return reply.status(400).send({ error: 'drinkType is required' })
    if (!body.timezone) return reply.status(400).send({ error: 'timezone is required' })

    const logId = await DrinkService.logDrink(userId, body)
    return reply.status(201).send({ logId })
  })

  app.patch<{ Params: { logId: string } }>('/:logId', async (req, reply) => {
    const userId = (req as any).userId
    await DrinkService.updateDrink(req.params.logId, userId, req.body as any)
    return reply.status(204).send()
  })

  app.delete<{ Params: { logId: string } }>('/:logId', async (req, reply) => {
    const userId = (req as any).userId
    await DrinkService.deleteDrink(req.params.logId, userId)
    return reply.status(204).send()
  })

  app.post('/analyze-photo', async (req, reply) => {
    const userId = (req as any).userId
    // In a real implementation, read multipart photo buffer here
    const result = await DrinkService.analyzePhoto(userId, Buffer.alloc(0))
    return reply.send(result)
  })
}

export default drinkRoutes
