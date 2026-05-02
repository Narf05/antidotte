import type { FastifyPluginAsync } from 'fastify'

const sessionRoutes: FastifyPluginAsync = async (app) => {
  // GET /sessions
  app.get('/', async (req, reply) => {
    // TODO: list user's sessions (history)
  })

  // POST /sessions
  app.post('/', async (req, reply) => {
    // TODO: create or start a new night-out session
  })

  // GET /sessions/:sessionId
  app.get('/:sessionId', async (req, reply) => {
    // TODO: get session detail
  })

  // PATCH /sessions/:sessionId
  app.patch('/:sessionId', async (req, reply) => {
    // TODO: update title, theme, privacy scope
  })

  // POST /sessions/:sessionId/end
  app.post('/:sessionId/end', async (req, reply) => {
    // TODO: end session, start 12-hour responsibility window
  })

  // DELETE /sessions/:sessionId
  app.delete('/:sessionId', async (req, reply) => {
    // TODO: soft-delete session, remove from stats
  })
}

export default sessionRoutes
