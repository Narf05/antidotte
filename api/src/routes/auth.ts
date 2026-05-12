import type { FastifyPluginAsync } from 'fastify'
import { AuthService } from '../services/AuthService'
import { requireAuth } from '../middleware/auth'

interface RegisterBody {
  username: string
  displayName: string
  password: string
}

interface LoginBody {
  username: string
  password: string
}

interface RefreshBody {
  refreshToken: string
}

const authRoutes: FastifyPluginAsync = async (app) => {
  app.post<{ Body: RegisterBody }>('/register', async (req, reply) => {
    const { username, displayName, password } = req.body
    if (!username || !displayName || !password) {
      return reply.status(400).send({ error: 'username, displayName, and password are required' })
    }
    if (password.length < 8) {
      return reply.status(400).send({ error: 'password must be at least 8 characters' })
    }
    try {
      const userId = await AuthService.register(username, displayName, password)
      const tokens = await AuthService.login(username, password)
      return reply.status(201).send({ userId, ...tokens })
    } catch (err: any) {
      if (err?.code === '23505') {
        return reply.status(409).send({ error: 'username already taken' })
      }
      throw err
    }
  })

  app.post<{ Body: LoginBody }>('/login', async (req, reply) => {
    const { username, password } = req.body
    if (!username || !password) {
      return reply.status(400).send({ error: 'username and password are required' })
    }
    const result = await AuthService.login(username, password)
    if (!result) return reply.status(401).send({ error: 'invalid credentials' })
    return reply.send(result)
  })

  app.post<{ Body: RefreshBody }>('/refresh', async (req, reply) => {
    const { refreshToken } = req.body
    if (!refreshToken) return reply.status(400).send({ error: 'refreshToken is required' })
    const accessToken = await AuthService.refreshToken(refreshToken)
    if (!accessToken) return reply.status(401).send({ error: 'invalid or expired refresh token' })
    return reply.send({ accessToken })
  })

  app.post('/logout', { preHandler: requireAuth }, async (req, reply) => {
    const { refreshToken } = req.body as any
    await AuthService.logout(refreshToken ?? '')
    return reply.status(204).send()
  })
}

export default authRoutes
