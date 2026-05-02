import SwiftUI

private let emojiPool = ["🍺", "🍷", "🥃", "🍹", "🎉", "🎵", "🌙", "⭐", "🍕", "🎸", "🦊", "🌊"]

struct MemoryTrayGame: View {
    let onComplete: (ActiveTestResult) -> Void

    @State private var phase: Phase = .showing
    @State private var shown: [String] = []
    @State private var guessed: [String] = []
    @State private var remaining: Int = 3

    enum Phase { case showing, recalling, done }

    var body: some View {
        ZStack {
            Color.antidotteBackground.ignoresSafeArea()

            VStack(spacing: 24) {
                switch phase {
                case .showing:
                    Text("Remember these items")
                        .font(.title3.bold())
                    HStack(spacing: 16) {
                        ForEach(shown, id: \.self) { emoji in
                            Text(emoji).font(.system(size: 48))
                        }
                    }
                    Text("Disappearing in \(remaining)s")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                case .recalling:
                    Text("Which items did you see?")
                        .font(.title3.bold())
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 64))], spacing: 16) {
                        ForEach(emojiPool.shuffled().prefix(12), id: \.self) { emoji in
                            Button {
                                if guessed.contains(emoji) {
                                    guessed.removeAll { $0 == emoji }
                                } else {
                                    guessed.append(emoji)
                                }
                            } label: {
                                Text(emoji)
                                    .font(.system(size: 40))
                                    .padding(10)
                                    .background(guessed.contains(emoji) ? Color.antidotteAccent.opacity(0.2) : Color.antidotteSurface)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay {
                                        if guessed.contains(emoji) {
                                            RoundedRectangle(cornerRadius: 12).stroke(Color.antidotteAccent, lineWidth: 2)
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 24)

                    Button("Done") { scoreAndFinish() }
                        .font(.headline)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(Color.antidotteAccent)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())

                case .done:
                    EmptyView()
                }
            }
            .padding()
        }
        .onAppear { startShowing() }
    }

    private func startShowing() {
        shown = Array(emojiPool.shuffled().prefix(4))
        remaining = 3
        phase = .showing

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            remaining -= 1
            if remaining <= 0 {
                timer.invalidate()
                withAnimation { phase = .recalling }
            }
        }
    }

    private func scoreAndFinish() {
        let correctCount = guessed.filter { shown.contains($0) }.count
        let wrongCount = guessed.count - correctCount
        let rawScore = Double(correctCount) - Double(wrongCount) * 0.5
        let normalized = max(0, min(100, rawScore / Double(shown.count) * 100))
        let result = ActiveTestResult(
            id: UUID().uuidString,
            userId: "",
            gameType: GameType.memoryTray.rawValue,
            rawScore: rawScore,
            normalizedScore: normalized,
            completedAt: Date()
        )
        result.confidence = 0.7
        phase = .done
        onComplete(result)
    }
}
