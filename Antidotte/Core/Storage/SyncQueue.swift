import Foundation

final class SyncQueue {
    static let shared = SyncQueue()
    private init() {}

    // TODO: queue offline actions (drink logs, session updates) and replay on reconnect
}
