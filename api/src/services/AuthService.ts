import { db } from '../db/client'
import bcrypt from 'bcryptjs'
import jwt from 'jsonwebtoken'
import { config } from '../config'

export class AuthService {
  static async register(username: string, displayName: string, password: string): Promise<string> {
    const passwordHash = await bcrypt.hash(password, 12)

    const [user] = await db`
      INSERT INTO users (username, display_name, password_hash)
      VALUES (${username}, ${displayName}, ${passwordHash})
      RETURNING id
    `

    const userId = user.id

    await db`
      INSERT INTO user_profiles (user_id) VALUES (${userId})
    `
    await db`
      INSERT INTO user_calibration (user_id, body_weight_kg) VALUES (${userId}, 70)
    `
    await db`
      INSERT INTO privacy_settings (user_id) VALUES (${userId})
    `

    return userId
  }

  static async login(
    username: string,
    password: string
  ): Promise<{ accessToken: string; refreshToken: string; userId: string } | null> {
    const [user] = await db`
      SELECT id, password_hash FROM users WHERE username = ${username} LIMIT 1
    `
    if (!user) return null

    const valid = await bcrypt.compare(password, user.password_hash)
    if (!valid) return null

    return AuthService.issueTokens(user.id)
  }

  static async refreshToken(token: string): Promise<string | null> {
    try {
      const payload = jwt.verify(token, config.jwtRefreshSecret) as { userId: string; type: string }
      if (payload.type !== 'refresh') return null

      const [user] = await db`SELECT id FROM users WHERE id = ${payload.userId} LIMIT 1`
      if (!user) return null

      return jwt.sign({ userId: payload.userId }, config.jwtSecret, { expiresIn: '15m' })
    } catch {
      return null
    }
  }

  static async logout(_refreshToken: string): Promise<void> {
    // Tokens are stateless; logout is handled client-side by discarding the tokens.
    // For full revocation, store a blocklist — skipped for v1.
  }

  private static issueTokens(userId: string): { accessToken: string; refreshToken: string; userId: string } {
    const accessToken = jwt.sign({ userId }, config.jwtSecret, { expiresIn: '15m' })
    const refreshToken = jwt.sign({ userId, type: 'refresh' }, config.jwtRefreshSecret, { expiresIn: '30d' })
    return { accessToken, refreshToken, userId }
  }
}
