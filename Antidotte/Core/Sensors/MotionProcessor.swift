import Foundation
import CoreMotion
import Combine

@MainActor
final class MotionProcessor: ObservableObject {
    static let shared = MotionProcessor()

    @Published private(set) var instabilityScore: Double = 0
    @Published private(set) var isActive = false

    private let motionManager = CMMotionManager()
    private var samples: [Double] = []
    private let sampleWindow = 60

    private init() {}

    func start() {
        guard motionManager.isAccelerometerAvailable else { return }
        isActive = true
        samples.removeAll()

        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            guard let data else { return }
            let magnitude = sqrt(
                data.acceleration.x * data.acceleration.x +
                data.acceleration.y * data.acceleration.y +
                data.acceleration.z * data.acceleration.z
            )
            // Deviation from 1g (gravity) reflects instability
            let deviation = abs(magnitude - 1.0)
            Task { @MainActor in self?.addSample(deviation) }
        }
    }

    func stop() {
        motionManager.stopAccelerometerUpdates()
        isActive = false
    }

    // Returns instability as a 0-100 score (0 = perfectly still, 100 = maximum instability)
    func currentInstabilityComponent() -> Double {
        instabilityScore
    }

    // MARK: - Private

    private func addSample(_ deviation: Double) {
        samples.append(deviation)
        if samples.count > sampleWindow {
            samples.removeFirst()
        }
        guard samples.count >= 10 else { return }

        let mean = samples.reduce(0, +) / Double(samples.count)
        // Typical sober deviation ≈ 0.05; very drunk ≈ 0.25+
        let normalized = min((mean / 0.30) * 100.0, 100.0)
        instabilityScore = normalized
    }
}
