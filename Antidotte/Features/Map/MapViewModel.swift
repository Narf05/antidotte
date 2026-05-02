import Foundation
import Combine

@MainActor
final class MapViewModel: ObservableObject {
    @Published var friendPresences: [FriendPresence] = []
    @Published var selectedFriend: FriendPresence? = nil
    @Published var showFriendProfile: Bool = false
    @Published var locationPrecision: LocationPrecision = .exact
    @Published var joinStatus: JoinStatus = .joinMe

    func logDrink() {
        // TODO: create DrinkLog locally, sync via APIClient
    }

    func selectFriend(_ presence: FriendPresence) {
        selectedFriend = presence
        showFriendProfile = true
    }
}
