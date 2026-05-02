import Foundation
import UIKit

@MainActor
final class PhoneUsageTracker: ObservableObject {
    static let shared = PhoneUsageTracker()

    @Published private(set) var deviationScore: Double = 0
    @Published private(set) var isActive = false

    // Metrics are derived only — no raw content is stored
    private var tapIntervals: [TimeInterval] = []
    private var lastTapTime: Date?
    private var sessionStartTime: Date?

    private init() {}

    func start() {
        isActive = true
        sessionStartTime = Date()
        tapIntervals.removeAll()
        lastTapTime = nil
    }

    func stop() {
        isActive = false
    }

    // Called from a custom UIWindow or gesture recognizer overlay (configured in SceneDelegate)
    func recordTap() {
        let now = Date()
        if let last = lastTapTime {
            tapIntervals.append(now.timeIntervalSince(last))
            if tapIntervals.count > 100 { tapIntervals.removeFirst() }
            updateScore()
        }
        lastTapTime = now
    }

    func currentDeviationComponent() -> Double {
        deviationScore
    }

    // MARK: - Private

    private func updateScore() {
        guard tapIntervals.count >= 5 else { return }

        let mean = tapIntervals.reduce(0, +) / Double(tapIntervals.count)
        let variance = tapIntervals.map { ($0 - mean) * ($0 - mean) }.reduce(0, +) / Double(tapIntervals.count)
        let stdDev = sqrt(variance)

        // Higher variance → higher deviation score (0–100)
        // Typical sober stdDev ≈ 0.15s; impaired ≈ 0.50s+
        deviationScore = min((stdDev / 0.60) * 100.0, 100.0)
    }
}
