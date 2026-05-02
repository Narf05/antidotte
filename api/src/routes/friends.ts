import type { FastifyPluginAsync } from 'fastify'

const friendRoutes: FastifyPluginAsync = async (app) => {
  // GET /friends
  app.get('/', async (req, reply) => {
    // TODO: list accepted friends
  })

  // POST /friends/request
  app.post('/request', async (req, reply) => {
    // TODO: send friend request (by userId, invite code, or contact match)
  })

  // PATCH /friends/request/:requestId
  app.patch('/request/:requestId', async (req, reply) => {
    // TODO: accept or decline a friend request
  })

  // DELETE /friends/:friendId
  app.delete('/:friendId', async (req, reply) => {
    // TODO: remove friend, revoke their access immediately
  })

  // POST /friends/block/:userId
  app.post('/block/:userId', async (req, reply) => {
    // TODO: block user, hide both from each other
  })

  // POST /friends/invite-code
  app.post('/invite-code', async (req, reply) => {
    // TODO: generate invite code, store hash, return code
  })
}

export default friendRoutes
