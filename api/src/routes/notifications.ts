import type { FastifyPluginAsync } from 'fastify'

const notificationRoutes: FastifyPluginAsync = async (app) => {
  // GET /notifications
  app.get('/', async (req, reply) => {
    // TODO: list notifications for current user
  })

  // PATCH /notifications/:id/read
  app.patch('/:id/read', async (req, reply) => {
    // TODO: mark notification as read
  })
}

export default notificationRoutes
