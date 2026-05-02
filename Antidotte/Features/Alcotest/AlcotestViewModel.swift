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
        // TODO: POST /score/active-test
    }
}
