import Foundation
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var displayName: String = ""
    @Published var username: String = ""
    @Published var currentScore: ScoreSnapshot? = nil
    @Published var joinStatus: JoinStatus = .joinMe
    @Published var locationPrecision: LocationPrecision = .exact
    @Published var isLoading = false

    func loadProfile() {
        isLoading = true
        Task {
            async let profileTask = APIClient.shared.getProfile()
            async let scoreTask = APIClient.shared.getCurrentScore()

            let profile = try? await profileTask
            let score = try? await scoreTask

            displayName = profile?["display_name"]?.value as? String ?? ""
            username = profile?["username"]?.value as? String ?? ""
            currentScore = score
            isLoading = false
        }
    }

    func startSession(title: String) async throws -> String {
        let response = try await APIClient.shared.startSession(title: title)
        return response.sessionId
    }

    func endSession(id: String) async throws {
        try await APIClient.shared.endSession(id: id)
    }
}
