import { db } from '../db/client'
import { WSServer } from '../websocket/WSServer'

const SESSION_START_FLOOR = 5
const POST_SESSION_MIN = 1

function tipsinessCategory(percentage: number): string {
  if (percentage < 5) return 'unknown'
  if (percentage < 20) return 'fresh'
  if (percentage < 40) return 'buzzing'
  if (percentage < 65) return 'loose'
  if (percentage < 85) return 'wavy'
  return 'gone_mode'
}

export class DrunkScoreService {
  static async recompute(userId: string, sessionId?: string): Promise<void> {
    const [calibration] = await db`
      SELECT body_weight_kg, usual_drinks_per_session, tolerance_self_rating
      FROM user_calibration WHERE user_id = ${userId}
    `

    // Fetch recent drink logs for current session / last 12h
    const drinks = await db`
      SELECT drink_unit_count, drank_at
      FROM drink_logs
      WHERE user_id = ${userId}
        AND is_deleted = false
        AND drank_at > now() - interval '12 hours'
      ORDER BY drank_at DESC
    `

    // Latest active test results (last 2h)
    const tests = await db`
      SELECT normalized_score, confidence, completed_at
      FROM active_test_results
      WHERE user_id = ${userId}
        AND completed_at > now() - interval '2 hours'
      ORDER BY completed_at DESC
      LIMIT 5
    `

    // Check if active session exists
    const [activeSession] = sessionId
      ? await db`SELECT id FROM night_out_sessions WHERE id = ${sessionId} AND is_active = true LIMIT 1`
      : await db`SELECT id FROM night_out_sessions WHERE user_id = ${userId} AND is_active = true LIMIT 1`

    const sessionFloorActive = !!activeSession

    // Drink log component: sum of units / calibrated capacity * 100
    const totalUnits = (drinks as any[]).reduce((sum: number, d: any) => sum + Number(d.drink_unit_count), 0)
    const capacity = calibration?.usual_drinks_per_session ?? 6
    const drinkLogComponent = Math.min((totalUnits / Number(capacity)) * 100, 100)

    // Active test component: weighted average of normalized scores
    let activeTestComponent: number | undefined
    if ((tests as any[]).length > 0) {
      const weighted = (tests as any[]).reduce((sum: number, t: any) => sum + Number(t.normalized_score), 0)
      activeTestComponent = weighted / (tests as any[]).length
    }

    const { percentage, confidence } = await DrunkScoreService.computeFromSignals({
      drinkLogComponent,
      activeTestComponent,
      sessionFloorActive,
    })

    const category = tipsinessCategory(percentage)
    const sid = sessionId ?? (activeSession as any)?.id ?? null

    await db`
      INSERT INTO drunk_score_snapshots
        (user_id, session_id, percentage, confidence, tipsiness_category,
         drink_log_component, active_test_component, session_floor_active)
      VALUES
        (${userId}, ${sid}, ${percentage}, ${confidence}, ${category},
         ${drinkLogComponent}, ${activeTestComponent ?? null}, ${sessionFloorActive})
    `

    // Push score update to friends who can see this user's score
    const friends = await db`
      SELECT
        CASE WHEN f.user_a_id = ${userId} THEN f.user_b_id ELSE f.user_a_id END AS friend_id
      FROM friendships f
      WHERE (f.user_a_id = ${userId} OR f.user_b_id = ${userId}) AND f.status = 'active'
    `

    const [settings] = await db`
      SELECT drunkness_visibility FROM privacy_settings WHERE user_id = ${userId}
    `

    const event = {
      type: 'score_update',
      userId,
      tipsinessCategory: category,
      ...(settings?.drunkness_visibility === 'percentage' ? { percentage } : {}),
      lastUpdatedAt: new Date().toISOString(),
    }

    WSServer.broadcast(
      (friends as any[]).map((f: any) => f.friend_id),
      event
    )
  }

  static async applySessionFloor(userId: string, _sessionId: string): Promise<void> {
    const [latest] = await db`
      SELECT percentage FROM drunk_score_snapshots
      WHERE user_id = ${userId}
      ORDER BY created_at DESC
      LIMIT 1
    `

    if (!latest || Number(latest.percentage) < SESSION_START_FLOOR) {
      await DrunkScoreService.recompute(userId, _sessionId)
    }
  }

  static async computeFromSignals(signals: {
    motionInstability?: number
    phoneUsageDeviation?: number
    drinkLogComponent?: number
    activeTestComponent?: number
    sessionFloorActive?: boolean
  }): Promise<{ percentage: number; confidence: number }> {
    const weights = {
      motionInstability: 0.25,
      phoneUsageDeviation: 0.15,
      drinkLogComponent: 0.40,
      activeTestComponent: 0.20,
    }

    let weightedSum = 0
    let totalWeight = 0

    const add = (value: number | undefined, weight: number) => {
      if (value !== undefined) {
        weightedSum += value * weight
        totalWeight += weight
      }
    }

    add(signals.motionInstability, weights.motionInstability)
    add(signals.phoneUsageDeviation, weights.phoneUsageDeviation)
    add(signals.drinkLogComponent, weights.drinkLogComponent)
    add(signals.activeTestComponent, weights.activeTestComponent)

    let percentage = totalWeight > 0 ? weightedSum / totalWeight : 0
    const confidence = Math.min(totalWeight, 1)

    if (signals.sessionFloorActive) {
      percentage = Math.max(percentage, SESSION_START_FLOOR)
    }

    percentage = Math.max(POST_SESSION_MIN, Math.min(100, percentage))

    return { percentage, confidence }
  }
}
