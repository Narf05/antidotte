import type { FastifyRequest, FastifyReply } from 'fastify'

// TODO: implement per-IP and per-user rate limiting
// Apply stricter limits on: /auth/login, /users/search, /friends/invite-code

export async function rateLimit(req: FastifyRequest, reply: FastifyReply): Promise<void> {
  // TODO
}
