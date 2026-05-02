import type { WebSocket } from 'ws'

// userId → active WebSocket connection
export const rooms = new Map<string, WebSocket>()

export function registerSocket(userId: string, ws: WebSocket): void {
  rooms.set(userId, ws)
  ws.on('close', () => rooms.delete(userId))
}
