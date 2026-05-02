import { db } from '../db/client'

export class AuthService {
  static async register(username: string, displayName: string, passwordHash: string): Promise<string> {
    // TODO: insert user, profile, calibration, privacy_settings rows; return userId
    return ''
  }

  static async login(username: string, password: string): Promise<{ accessToken: string; refreshToken: string } | null> {
    // TODO: find user, verify password, return JWTs
    return null
  }

  static async refreshToken(token: string): Promise<string | null> {
    // TODO: verify refresh token, return new access token
    return null
  }
}
