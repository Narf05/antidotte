import type { FastifyPluginAsync } from 'fastify'

const scoreRoutes: FastifyPluginAsync = async (app) => {
  // GET /score/current
  app.get('/current', async (req, reply) => {
    // TODO: return current score snapshot for the user
  })

  // GET /score/history
  app.get('/history', async (req, reply) => {
    // TODO: return score snapshots for a time range (for stats chart)
  })

  // POST /score/active-test
  app.post('/active-test', async (req, reply) => {
    // TODO: receive active test results, store in active_test_results,
    //       trigger DrunkScoreService recompute, push updated score via WebSocket
  })
}

export default scoreRoutes
