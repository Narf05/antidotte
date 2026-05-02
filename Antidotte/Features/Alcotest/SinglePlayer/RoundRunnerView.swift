import SwiftUI

struct RoundRunnerView: View {
    let games: [GameType]
    @ObservedObject var viewModel: AlcotestViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var currentIndex = 0
    @State private var showSummary = false

    private var currentGame: GameType? {
        guard currentIndex < games.count else { return nil }
        return games[currentIndex]
    }

    var body: some View {
        ZStack {
            Color.antidotteBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress bar
                HStack(spacing: 6) {
                    ForEach(0..<games.count, id: \.self) { i in
                        Capsule()
                            .fill(i <= currentIndex ? Color.antidotteAccent : Color.gray.opacity(0.25))
                            .frame(height: 4)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 8)

                if showSummary {
                    roundSummary
                } else if let game = currentGame {
                    gameView(for: game)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                }
            }
        }
    }

    @ViewBuilder
    private func gameView(for game: GameType) -> some View {
        let complete: (ActiveTestResult) -> Void = { result in
            viewModel.results.append(result)
            withAnimation {
                if currentIndex + 1 < games.count {
                    currentIndex += 1
                } else {
                    showSummary = true
                }
            }
        }

        switch game {
        case .tapTheDot:    TapTheDotGame(onComplete: complete)
        case .holdStill:    HoldStillGame(onComplete: complete)
        case .memoryTray:   MemoryTrayGame(onComplete: complete)
        case .straightLine: StraightLineGame(onComplete: complete)
        case .vibeCheck:    VibeCheckGame(onComplete: complete)
        default:            VibeCheckGame(onComplete: complete)
        }
    }

    private var roundSummary: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(Color.antidotteAccent)

            Text("Round complete!")
                .font(.title2.bold())

            let avg = viewModel.results.map(\.normalizedScore).reduce(0, +) / max(1, Double(viewModel.results.count))
            Text("Average score: \(Int(avg))%")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()

            VStack(spacing: 12) {
                Button {
                    viewModel.submitResults()
                    dismiss()
                } label: {
                    Text("Submit & update score")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.antidotteAccent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                Button("Discard") {
                    viewModel.results.removeAll()
                    dismiss()
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}
