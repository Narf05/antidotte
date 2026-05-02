import { db } from '../db/client'
import { WSServer } from '../websocket/WSServer'

export class LocationService {
  static async updatePresence(userId: string, lat: number, lon: number, accuracyM: number): Promise<void> {
    // TODO: upsert live_location_presence, check panic_privacy, push filtered payloads
  }

  static async getVisibleFriendsFor(viewerId: string): Promise<unknown[]> {
    // TODO: fetch allowed friend presences, apply visibility rules per viewer
    return []
  }

  static applyApproximation(lat: number, lon: number): { lat: number; lon: number } {
    // Round to 3 decimal places for ~150m precision
    return {
      lat: Math.round(lat * 1000) / 1000,
      lon: Math.round(lon * 1000) / 1000,
    }
  }
}
