import Fastify from 'fastify'
import { config } from './config'
import { db } from './db/client'
import { WSServer } from './websocket/WSServer'
import authRoutes from './routes/auth'
import userRoutes from './routes/users'
import friendRoutes from './routes/friends'
import groupRoutes from './routes/groups'
import sessionRoutes from './routes/sessions'
import drinkRoutes from './routes/drinks'
import locationRoutes from './routes/location'
import scoreRoutes from './routes/score'
import notificationRoutes from './routes/notifications'

const app = Fastify({ logger: true })

app.register(authRoutes, { prefix: '/auth' })
app.register(userRoutes, { prefix: '/users' })
app.register(friendRoutes, { prefix: '/friends' })
app.register(groupRoutes, { prefix: '/groups' })
app.register(sessionRoutes, { prefix: '/sessions' })
app.register(drinkRoutes, { prefix: '/drinks' })
app.register(locationRoutes, { prefix: '/location' })
app.register(scoreRoutes, { prefix: '/score' })
app.register(notificationRoutes, { prefix: '/notifications' })

const start = async () => {
  await app.listen({ port: config.port, host: '0.0.0.0' })
  WSServer.init(app.server)
}

start().catch(console.error)
