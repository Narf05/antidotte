import Foundation

// Persists pending API actions across app restarts using UserDefaults.
// Actions are replayed in order when connectivity is restored.
final class SyncQueue {
    static let shared = SyncQueue()

    private let key = "antidotte_sync_queue"
    private var queue: [PendingAction] = []
    private var replayTask: Task<Void, Never>?

    private init() {
        load()
    }

    // MARK: - Types

    struct PendingAction: Codable {
        let id: String
        let endpoint: String
        let method: String
        let body: Data?
        let enqueuedAt: Date
    }

    // MARK: - Enqueue

    func enqueue(endpoint: String, method: String, body: Encodable?) {
        let bodyData = body.flatMap { try? JSONEncoder.api.encode($0) }
        let action = PendingAction(
            id: UUID().uuidString,
            endpoint: endpoint,
            method: method,
            body: bodyData,
            enqueuedAt: Date()
        )
        queue.append(action)
        persist()
    }

    // MARK: - Replay

    func replayAll() {
        replayTask?.cancel()
        replayTask = Task {
            var remaining: [PendingAction] = []
            for action in queue {
                guard !Task.isCancelled else { break }
                let success = await replay(action)
                if !success { remaining.append(action) }
            }
            queue = remaining
            persist()
        }
    }

    var hasPending: Bool { !queue.isEmpty }

    // MARK: - Private

    private func replay(_ action: PendingAction) async -> Bool {
        guard let url = URL(string: (Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String ?? "http://localhost:3000") + action.endpoint) else {
            return false
        }
        var req = URLRequest(url: url)
        req.httpMethod = action.method
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = AuthManager.shared.accessToken {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        req.httpBody = action.body

        do {
            let (_, response) = try await URLSession.shared.data(for: req)
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            return (200..<300).contains(status)
        } catch {
            return false
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([PendingAction].self, from: data) else { return }
        queue = decoded
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(queue) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
