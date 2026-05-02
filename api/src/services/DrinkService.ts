import { db } from '../db/client'
import { DrunkScoreService } from './DrunkScoreService'

export class DrinkService {
  static async logDrink(userId: string, data: {
    sessionId?: string
    drankAt?: string
    timezone: string
    source?: string
    drinkUnitCount?: number
    alcoholPercentage?: number
    volumeMl?: number
    drinkType: string
    priceAmount?: number
    priceCurrency?: string
    note?: string
    enteredWhileOffline?: boolean
    clientCreatedAt?: string
  }): Promise<string> {
    const drankAt = data.drankAt ?? new Date().toISOString()

    const [row] = await db`
      INSERT INTO drink_logs
        (user_id, session_id, drank_at, timezone, source, drink_unit_count,
         alcohol_percentage, volume_ml, drink_type, price_amount, price_currency,
         note, entered_while_offline, client_created_at)
      VALUES
        (${userId}, ${data.sessionId ?? null}, ${drankAt}, ${data.timezone},
         ${data.source ?? 'plus_one'}, ${data.drinkUnitCount ?? 1.0},
         ${data.alcoholPercentage ?? null}, ${data.volumeMl ?? null},
         ${data.drinkType}, ${data.priceAmount ?? null}, ${data.priceCurrency ?? null},
         ${data.note ?? null}, ${data.enteredWhileOffline ?? false},
         ${data.clientCreatedAt ?? null})
      RETURNING id
    `

    await DrunkScoreService.recompute(userId, data.sessionId)

    return row.id
  }

  static async updateDrink(logId: string, userId: string, data: {
    drinkType?: string
    drinkUnitCount?: number
    alcoholPercentage?: number
    volumeMl?: number
    priceAmount?: number
    priceCurrency?: string
    note?: string
  }): Promise<void> {
    await db`
      UPDATE drink_logs SET
        drink_type = COALESCE(${data.drinkType ?? null}, drink_type),
        drink_unit_count = COALESCE(${data.drinkUnitCount ?? null}, drink_unit_count),
        alcohol_percentage = COALESCE(${data.alcoholPercentage ?? null}, alcohol_percentage),
        volume_ml = COALESCE(${data.volumeMl ?? null}, volume_ml),
        price_amount = COALESCE(${data.priceAmount ?? null}, price_amount),
        price_currency = COALESCE(${data.priceCurrency ?? null}, price_currency),
        note = COALESCE(${data.note ?? null}, note),
        updated_at = now()
      WHERE id = ${logId} AND user_id = ${userId} AND is_deleted = false
    `

    const [log] = await db`SELECT session_id FROM drink_logs WHERE id = ${logId}`
    await DrunkScoreService.recompute(userId, log?.session_id)
  }

  static async deleteDrink(logId: string, userId: string): Promise<void> {
    const [log] = await db`
      UPDATE drink_logs
      SET is_deleted = true, updated_at = now()
      WHERE id = ${logId} AND user_id = ${userId}
      RETURNING session_id
    `
    await DrunkScoreService.recompute(userId, log?.session_id)
  }

  static async listDrinks(userId: string, sessionId?: string, limit = 50, offset = 0): Promise<unknown[]> {
    if (sessionId) {
      return db`
        SELECT * FROM drink_logs
        WHERE user_id = ${userId} AND session_id = ${sessionId} AND is_deleted = false
        ORDER BY drank_at DESC
        LIMIT ${limit} OFFSET ${offset}
      `
    }
    return db`
      SELECT * FROM drink_logs
      WHERE user_id = ${userId} AND is_deleted = false
      ORDER BY drank_at DESC
      LIMIT ${limit} OFFSET ${offset}
    `
  }

  static async analyzePhoto(_userId: string, _photoBuffer: Buffer): Promise<Record<string, unknown>> {
    // Photo analysis requires a vision model integration (not bundled in v1).
    // Returns placeholder detected values so the client can review + confirm.
    return {
      detectedDrinkType: 'beer',
      detectedVolumeMl: 330,
      detectedAlcoholPercentage: 5.0,
      detectedPriceAmount: null,
      detectionConfidence: 0.0,
      note: 'photo_analysis_unavailable',
    }
  }
}
