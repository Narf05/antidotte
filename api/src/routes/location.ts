import type { FastifyPluginAsync } from 'fastify'

const locationRoutes: FastifyPluginAsync = async (app) => {
  // POST /location/presence
  app.post('/presence', async (req, reply) => {
    // TODO: receive location update, apply precision, store sample,
    //       push filtered payloads to allowed friends via WebSocket
  })

  // GET /location/friends
  app.get('/friends', async (req, reply) => {
    // TODO: return allowed friend presence payloads for initial map load
  })

  // GET /location/visibility-rules
  app.get('/visibility-rules', async (req, reply) => {
    // TODO: return user's location visibility rules
  })

  // POST /location/visibility-rules
  app.post('/visibility-rules', async (req, reply) => {
    // TODO: create or update a visibility rule (per friend or per group)
  })

  // DELETE /location/visibility-rules/:ruleId
  app.delete('/visibility-rules/:ruleId', async (req, reply) => {
    // TODO: delete visibility rule
  })
}

export default locationRoutes
