import type { FastifyRequest, FastifyReply } from 'fastify'
import { PrivacyService } from '../services/PrivacyService'

// Reusable middleware factory — checks a specific privacy toggle before proceeding
export function requireConsent(consentType: string) {
  return async (req: FastifyRequest, reply: FastifyReply): Promise<void> => {
    const userId = (req as any).userId
    const allowed = await PrivacyService.checkConsent(userId, consentType)
    if (!allowed) {
      reply.status(403).send({ error: `${consentType} consent not granted` })
    }
  }
}
