import SwiftUI

struct StraightLineGame: View {
    let onComplete: (ActiveTestResult) -> Void

    @State private var path: [CGPoint] = []
    @State private var done = false
    @GestureState private var isDragging = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.antidotteBackground.ignoresSafeArea()

                // Target line
                Path { p in
                    let y = geo.size.height / 2
                    p.move(to: CGPoint(x: 40, y: y))
                    p.addLine(to: CGPoint(x: geo.size.width - 40, y: y))
                }
                .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 3, dash: [8, 6]))

                // User path
                if !path.isEmpty {
                    Path { p in
                        p.move(to: path[0])
                        for point in path.dropFirst() { p.addLine(to: point) }
                    }
                    .stroke(Color.antidotteAccent, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                }

                VStack {
                    Text(done ? "Done!" : "Trace the dashed line with your finger")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, 24)
                    Spacer()
                    if !done {
                        Text("Swipe from left to right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                            .padding(.bottom, 32)
                    }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if !done { path.append(value.location) }
                    }
                    .onEnded { _ in
                        if path.count > 10 { scoreAndFinish(in: geo.size) }
                    }
            )
        }
    }

    private func scoreAndFinish(in size: CGSize) {
        done = true
        let targetY = size.height / 2
        let deviations = path.map { abs($0.y - targetY) }
        let avgDeviation = deviations.reduce(0, +) / Double(max(1, deviations.count))
        // < 20px avg deviation = 100, > 100px = 0
        let normalized = max(0, min(100, (100 - avgDeviation) / 0.80))
        let result = ActiveTestResult(
            id: UUID().uuidString,
            userId: "",
            gameType: GameType.straightLine.rawValue,
            rawScore: avgDeviation,
            normalizedScore: normalized,
            completedAt: Date()
        )
        result.confidence = 0.8
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { onComplete(result) }
    }
}
