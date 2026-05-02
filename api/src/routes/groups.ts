import type { FastifyPluginAsync } from 'fastify'

const groupRoutes: FastifyPluginAsync = async (app) => {
  // GET /groups
  app.get('/', async (req, reply) => {
    // TODO: list user's groups
  })

  // POST /groups
  app.post('/', async (req, reply) => {
    // TODO: create group
  })

  // PATCH /groups/:groupId
  app.patch('/:groupId', async (req, reply) => {
    // TODO: rename group, change visibility
  })

  // DELETE /groups/:groupId
  app.delete('/:groupId', async (req, reply) => {
    // TODO: delete group, revoke group-based location access
  })

  // POST /groups/:groupId/members
  app.post('/:groupId/members', async (req, reply) => {
    // TODO: add friend to group
  })

  // DELETE /groups/:groupId/members/:userId
  app.delete('/:groupId/members/:userId', async (req, reply) => {
    // TODO: remove member from group
  })
}

export default groupRoutes
