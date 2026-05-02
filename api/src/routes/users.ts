import type { FastifyPluginAsync } from 'fastify'

const userRoutes: FastifyPluginAsync = async (app) => {
  // GET /users/me
  app.get('/me', async (req, reply) => {
    // TODO: return current user profile
  })

  // PATCH /users/me
  app.patch('/me', async (req, reply) => {
    // TODO: update display name, username, profile image
  })

  // GET /users/me/calibration
  app.get('/me/calibration', async (req, reply) => {
    // TODO: return calibration data (private)
  })

  // PATCH /users/me/calibration
  app.patch('/me/calibration', async (req, reply) => {
    // TODO: update body weight, sports, drink unit definition etc.
  })

  // GET /users/me/settings
  app.get('/me/settings', async (req, reply) => {
    // TODO: return privacy_settings
  })

  // PATCH /users/me/settings
  app.patch('/me/settings', async (req, reply) => {
    // TODO: update any privacy toggle, panic privacy, style mode etc.
  })

  // GET /users/search?q=
  app.get('/search', async (req, reply) => {
    // TODO: search by username, respect search visibility setting
  })
}

export default userRoutes
