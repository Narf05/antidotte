import { WebSocketServer, type WebSocket } from 'ws'
import type { Server } from 'http'
import { rooms } from './rooms'

export class WSServer {
  private static wss: WebSocketServer

  static init(server: Server): void {
    this.wss = new WebSocketServer({ server })

    this.wss.on('connection', (ws: WebSocket, req) => {
      // TODO: authenticate connection via JWT query param or first message
      // Register socket in rooms
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
