import SwiftUI

private struct VibeQuestion {
    let text: String
    let options: [(label: String, score: Double)]
}

private let questions: [VibeQuestion] = [
    VibeQuestion(
        text: "How do you feel right now?",
        options: [("Completely sober", 0), ("A little warm", 30), ("Buzzing", 55), ("Properly drunk", 80), ("Very drunk", 100)]
    ),
    VibeQuestion(
        text: "How's your balance?",
        options: [("Rock solid", 0), ("Mostly fine", 25), ("Slightly wobbly", 55), ("Need support", 85)]
    ),
    VibeQuestion(
        text: "How focused are you?",
        options: [("Crystal clear", 0), ("Slightly foggy", 35), ("Quite hazy", 65), ("Very foggy", 95)]
    ),
]

struct VibeCheckGame: View {
    let onComplete: (ActiveTestResult) -> Void

    @State private var questionIndex = 0
    @State private var scores: [Double] = []

    private var current: VibeQuestion { questions[questionIndex] }

    var body: some View {
        ZStack {
            Color.antidotteBackground.ignoresSafeArea()

            VStack(spacing: 28) {
                Text("Vibe check")
                    .font(.title2.bold())

                Text(current.text)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                VStack(spacing: 10) {
                    ForEach(current.options, id: \.label) { option in
                        Button {
                            scores.append(option.score)
                            advance()
                        } label: {
                            Text(option.label)
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.antidotteSurface)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)

                Text("\(questionIndex + 1) / \(questions.count)")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
    }

    private func advance() {
        if questionIndex + 1 < questions.count {
            questionIndex += 1
        } else {
            let avg = scores.reduce(0, +) / Double(max(1, scores.count))
            let result = ActiveTestResult(
                id: UUID().uuidString,
                userId: "",
                gameType: GameType.vibeCheck.rawValue,
                rawScore: avg,
                normalizedScore: avg,
                completedAt: Date()
            )
            result.confidence = 0.5
            onComplete(result)
        }
    }
}
