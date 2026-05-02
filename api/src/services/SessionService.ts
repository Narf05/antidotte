import { db } from '../db/client'
import { DrunkScoreService } from './DrunkScoreService'

export class SessionService {
  static async startSession(userId: string, title: string, theme?: string): Promise<string> {
    // TODO: insert night_out_sessions, set auto_end_at to now + 4h,
    //       trigger DrunkScoreService to apply session start floor
    return ''
  }

  static async endSession(sessionId: string, userId: string): Promise<void> {
    // TODO: set ended_at, is_active=false, schedule post-session 12h window
  }

  static async autoEndIfInactive(sessionId: string): Promise<void> {
    // TODO: called by a background job — ends session after 4h of no relevant activity
  }
}
