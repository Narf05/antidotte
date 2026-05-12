import SwiftUI

enum GameType: String, CaseIterable {
    case tapTheDot    = "tap_the_dot"
    case straightLine = "straight_line"
    case memoryTray   = "memory_tray"
    case holdStill    = "hold_still"
    case readItRight  = "read_it_right"
    case tongueTwister = "tongue_twister"
    case vibeCheck    = "vibe_check"
}

struct TapTheDotGame: View {
    let onComplete: (ActiveTestResult) -> Void

    @State private var dotPosition: CGPoint = CGPoint(x: 0.5, y: 0.5)
    @State private var tapCount = 0
    @State private var totalReactionMs: Double = 0
    @State private var shownAt: Date = Date()
    @State private var done = false

    private let totalTaps = 8
    private let dotRadius: CGFloat = 32

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.antidotteBackground.ignoresSafeArea()

                VStack {
                    Text("Tap the dot as fast as you can")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, 24)
                    Spacer()
                }

                if !done {
                    Circle()
                        .fill(Color.antidotteAccent)
                        .frame(width: dotRadius * 2, height: dotRadius * 2)
                        .position(
                            x: dotPosition.x * geo.size.width,
                            y: dotPosition.y * geo.size.height
                        )
                        .onTapGesture { handleTap() }
                        .animation(.easeOut(duration: 0.12), value: dotPosition)
                }

                Text("\(tapCount)/\(totalTaps)")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(20)
            }
        }
        .onAppear { moveDot(); shownAt = Date() }
    }

    private func handleTap() {
        let ms = Date().timeIntervalSince(shownAt) * 1000
        totalReactionMs += ms
        tapCount += 1
        shownAt = Date()

        if tapCount >= totalTaps {
            done = true
            let avgMs = totalReactionMs / Double(totalTaps)
            // Normalize: <300ms = 100, >1500ms = 0
            let normalized = max(0, min(100, (1500 - avgMs) / 12.0))
            let result = ActiveTestResult(
                id: UUID().uuidString,
                userId: "",
                gameType: GameType.tapTheDot.rawValue,
                rawScore: avgMs,
                normalizedScore: normalized,
                completedAt: Date()
            )
            result.confidence = 0.9
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { onComplete(result) }
        } else {
            moveDot()
        }
    }

    private func moveDot() {
        dotPosition = CGPoint(
            x: Double.random(in: 0.15...0.85),
            y: Double.random(in: 0.20...0.80)
        )
    }
}
