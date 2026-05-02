import SwiftUI
import CoreMotion

struct HoldStillGame: View {
    let onComplete: (ActiveTestResult) -> Void

    @State private var countdown = 5
    @State private var measuring = false
    @State private var deviations: [Double] = []
    @State private var done = false
    @State private var instructionText = "Hold the phone perfectly still"

    private let motionManager = CMMotionManager()
    private let duration = 5

    var body: some View {
        ZStack {
            Color.antidotteBackground.ignoresSafeArea()

            VStack(spacing: 32) {
                Text(instructionText)
                    .font(.title3.bold())
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                        .frame(width: 160, height: 160)

                    Circle()
                        .trim(from: 0, to: measuring ? CGFloat(countdown) / CGFloat(duration) : 1)
                        .stroke(Color.antidotteAccent, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 160, height: 160)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: countdown)

                    Text(measuring ? "\(countdown)s" : "Ready")
                        .font(.title2.bold())
                        .monospacedDigit()
                }

                if !measuring && !done {
                    Button("Start") { startMeasuring() }
                        .font(.headline)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(Color.antidotteAccent)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
            }
        }
        .onDisappear { motionManager.stopAccelerometerUpdates() }
    }

    private func startMeasuring() {
        measuring = true
        countdown = duration
        deviations.removeAll()
        instructionText = "Keep steady…"

        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: .main) { data, _ in
            guard let data else { return }
            let mag = sqrt(data.acceleration.x * data.acceleration.x +
                           data.acceleration.y * data.acceleration.y +
                           data.acceleration.z * data.acceleration.z)
            deviations.append(abs(mag - 1.0))
        }

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            countdown -= 1
            if countdown <= 0 {
                timer.invalidate()
                motionManager.stopAccelerometerUpdates()
                finish()
            }
        }
    }

    private func finish() {
        done = true
        let avg = deviations.isEmpty ? 0.3 : deviations.reduce(0, +) / Double(deviations.count)
        // Low deviation = high score. 0.05 = 100, 0.30 = 0
        let normalized = max(0, min(100, (0.30 - avg) / 0.25 * 100))
        let result = ActiveTestResult(
            id: UUID().uuidString,
            userId: "",
            gameType: GameType.holdStill.rawValue,
            rawScore: avg,
            normalizedScore: normalized,
            completedAt: Date()
        )
        result.confidence = 0.85
        onComplete(result)
    }
}
