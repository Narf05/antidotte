import Foundation

@MainActor
final class AlcotestViewModel: ObservableObject {
    @Published var mode: AlcotestMode? = nil
    @Published var currentRound: [GameType] = []
    @Published var results: [ActiveTestResult] = []

    enum AlcotestMode {
        case singlePlayer
        case multiplayer
    }

    func startQuickRound() {
        currentRound = [.tapTheDot, .holdStill, .vibeCheck]
    }

    func startFullRound() {
        currentRound = [.tapTheDot, .straightLine, .memoryTray, .holdStill, .vibeCheck]
    }

    func submitResults() {
        Task {
            for result in results {
                let submission = ActiveTestSubmission(
                    gameType: result.gameType,
                    rawScore: result.rawScore,
                    normalizedScore: result.normalizedScore,
                    confidence: result.confidence,
                    roundType: result.roundType,
                    sessionId: nil
                )
                _ = try? await APIClient.shared.submitActiveTest(submission)
            }
            await MainActor.run {
                results.removeAll()
                currentRound.removeAll()
                mode = nil
            }
        }
    }
}
