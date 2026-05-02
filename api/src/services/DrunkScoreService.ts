import { db } from '../db/client'
import { WSServer } from '../websocket/WSServer'

// Session start creates a score floor of 5% that persists until 12h after session ends
const SESSION_START_FLOOR = 5
const POST_SESSION_MIN = 1

export class DrunkScoreService {
  static async recompute(userId: string, sessionId?: string): Promise<void> {
    // TODO: gather motion, phone usage, drink logs, active test results
    //       apply user calibration, compute weighted percentage + confidence
    //       enforce session floor if active session exists
    //       write drunk_score_snapshot
    //       push updated score to allowed friends via WebSocket
  }

  static async applySessionFloor(userId: string, sessionId: string): Promise<void> {
    // TODO: ensure score >= SESSION_START_FLOOR for active session
  }

  static async computeFromSignals(signals: {
    motionInstability?: number
    phoneUsageDeviation?: number
    drinkLogComponent?: number
    activeTestComponent?: number
    sessionFloorActive?: boolean
  }): Promise<{ percentage: number; confidence: number }> {
    // TODO: weighted aggregation of signals
    return { percentage: 0, confidence: 0 }
  }
}
