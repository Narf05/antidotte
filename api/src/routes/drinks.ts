import type { FastifyPluginAsync } from 'fastify'

const drinkRoutes: FastifyPluginAsync = async (app) => {
  // GET /drinks
  app.get('/', async (req, reply) => {
    // TODO: list drink logs for current user (paginated)
  })

  // POST /drinks
  app.post('/', async (req, reply) => {
    // TODO: log a drink (+1 or manual), trigger score recompute
  })

  // PATCH /drinks/:logId
  app.patch('/:logId', async (req, reply) => {
    // TODO: edit drink log
  })

  // DELETE /drinks/:logId
  app.delete('/:logId', async (req, reply) => {
    // TODO: soft-delete drink log, recompute score
  })

  // POST /drinks/analyze-photo
  app.post('/analyze-photo', async (req, reply) => {
    // TODO: receive photo, run detection, return detected values without saving drink yet
  })
}

export default drinkRoutes
