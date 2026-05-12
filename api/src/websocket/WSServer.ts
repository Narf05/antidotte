import { WebSocketServer, type WebSocket } from 'ws'
import type { Server } from 'http'
import jwt from 'jsonwebtoken'
import { config } from '../config'
import { rooms, registerSocket } from './rooms'

export class WSServer {
  private static wss: WebSocketServer

  static init(server: Server): void {
    this.wss = new WebSocketServer({ server, path: '/ws' })

    this.wss.on('connection', (ws: WebSocket, req) => {
      // Authenticate via ?token= query param
      const url = new URL(req.url ?? '', `http://localhost`)
      const token = url.searchParams.get('token')

      if (!token) {
        ws.close(4001, 'missing token')
        return
      }

      let userId: string
      try {
        const payload = jwt.verify(token, config.jwtSecret) as { userId: string }
        userId = payload.userId
      } catch {
        ws.close(4001, 'invalid token')
        return
      }

      registerSocket(userId, ws)

      ws.on('message', (data) => {
        // Client heartbeat: { type: 'ping' } → respond { type: 'pong' }
        try {
          const msg = JSON.parse(data.toString())
          if (msg?.type === 'ping') {
            ws.send(JSON.stringify({ type: 'pong' }))
          }
        } catch {
          // ignore malformed messages
        }
      })

      ws.send(JSON.stringify({ type: 'connected', userId }))
    })
  }

  static sendToUser(userId: string, event: object): void {
    const socket = rooms.get(userId)
    if (socket?.readyState === 1) {
      socket.send(JSON.stringify(event))
    }
  }

  static broadcast(userIds: string[], event: object): void {
    for (const userId of userIds) {
      this.sendToUser(userId, event)
    }
  }
}
