import type { FastifyPluginAsync } from 'fastify'

const authRoutes: FastifyPluginAsync = async (app) => {
  // POST /auth/register
  app.post('/register', async (req, reply) => {
    // TODO: validate body, hash password, create user + profile + calibration + privacy_settings rows
  })

  // POST /auth/login
  app.post('/login', async (req, reply) => {
    // TODO: verify credentials, return access + refresh JWT
  })

  // POST /auth/refresh
  app.post('/refresh', async (req, reply) => {
    // TODO: verify refresh token, return new access token
  })

  // POST /auth/logout
  app.post('/logout', async (req, reply) => {
    // TODO: invalidate refresh token
  })
}

export default authRoutes
