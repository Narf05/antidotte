// Typed WebSocket event payloads sent from backend to iOS clients

export type WSEvent =
  | LocationUpdateEvent
  | ScoreUpdateEvent
  | FriendStatusEvent
  | SessionEvent

export interface LocationUpdateEvent {
  type: 'location_update'
  userId: string
  visibility: 'exact' | 'approximate_150m' | 'hidden'
  lat?: number
  lon?: number
  roughAreaLat?: number
  roughAreaLon?: number
  lastSeenAt: string
  sessionId?: string
}

export interface ScoreUpdateEvent {
  type: 'score_update'
  userId: string
  tipsinessCategory: string
  percentage?: number
  lastUpdatedAt: string
}

export interface FriendStatusEvent {
  type: 'friend_status'
  userId: string
  joinStatus: 'join_me' | 'do_not_join'
  presenceState: 'live' | 'stale' | 'hidden' | 'location_off'
}

export interface SessionEvent {
  type: 'session_started' | 'session_ended'
  userId: string
  sessionId: string
  sessionTitle?: string
}
