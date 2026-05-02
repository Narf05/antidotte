import { db } from '../db/client'
import { DrunkScoreService } from './DrunkScoreService'

export class DrinkService {
  static async logDrink(userId: string, data: Record<string, unknown>): Promise<string> {
    // TODO: insert drink_log, trigger DrunkScoreService.recompute
    return ''
  }

  static async deleteDrink(logId: string, userId: string): Promise<void> {
    // TODO: soft-delete drink_log (is_deleted = true), trigger recompute
  }

  static async analyzePhoto(userId: string, photoBuffer: Buffer): Promise<Record<string, unknown>> {
    // TODO: run image analysis, return detected drink type/volume/ABV/price
    //       do not store photo unless save_drink_photos_enabled = true
    return {}
  }
}
