import Foundation

final class PhoneUsageTracker {
    static let shared = PhoneUsageTracker()
    private init() {}

    // TODO: track typing deviation, tap accuracy, unlock patterns
    // Only active when phone_usage_tracking_enabled = true
    // Store derived metrics only — no raw message content
}
