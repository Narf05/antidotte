import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var currentSession: NightOutSession? = nil
    @Published var joinStatus: JoinStatus = .joinMe
    @Published var locationPrecision: LocationPrecision = .exact

    func loadProfile() {
        // TODO: load from local storage and sync with API
    }
}
