import Foundation
import Combine

@MainActor
final class MapViewModel: ObservableObject {
    @Published var friendPresences: [FriendPresence] = []
    @Published var selectedFriend: FriendPresence? = nil
    @Published var showFriendProfile: Bool = false
    @Published var locationPrecision: LocationPrecision = .exact
    @Published var joinStatus: JoinStatus = .joinMe

    private var wsTask: AnyCancellable?

    init() {
        subscribeToWebSocket()
        Task { await loadFriendPresences() }
    }

    func logDrink() {
        Task {
            let tz = TimeZone.current.identifier
            _ = try? await APIClient.shared.logDrink([
                "drinkType": AnyEncodable("plus_one"),
                "timezone": AnyEncodable(tz),
                "source": AnyEncodable("plus_one"),
            ])
        }
    }

    func selectFriend(_ presence: FriendPresence) {
        selectedFriend = presence
        showFriendProfile = true
    }

    func updatePrecision(_ precision: LocationPrecision) {
        locationPrecision = precision
        Task {
            let value: String
            switch precision {
            case .exact:          value = "exact"
            case .approximate150m: value = "rough_area"
            case .off:             value = "off"
            }
            try? await APIClient.shared.updateSettings(["locationPrecision": AnyEncodable(value)])
        }
    }

    // MARK: - Private

    private func loadFriendPresences() async {
        guard let dtos = try? await APIClient.shared.getFriendPresences() else { return }
        // Map DTOs to local FriendPresence model objects (in-memory, not persisted)
        self.friendPresences = dtos.map { dto in
            let p = FriendPresence(
                userId: dto.userId,
                displayName: dto.displayName,
                visibility: dto.visibility,
                lastSeenAt: Date()
            )
            p.latitude = dto.lat
            p.longitude = dto.lon
            p.roughAreaLatitude = dto.roughAreaLat
            p.roughAreaLongitude = dto.roughAreaLon
            p.presenceState = dto.presenceState
            p.sessionId = dto.sessionId
            if let js = dto.joinStatus { p.joinStatus = js }
            return p
        }
    }

    private func subscribeToWebSocket() {
        wsTask = WebSocketClient.shared.events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                self?.handle(event)
            }
        WebSocketClient.shared.connect()
    }

    private func handle(_ event: WSEvent) {
        switch event {
        case .locationUpdate(let payload):
            applyLocationUpdate(payload)
        case .scoreUpdate(let payload):
            applyScoreUpdate(payload)
        case .friendStatus(let payload):
            applyFriendStatus(payload)
        default:
            break
        }
    }

    private func applyLocationUpdate(_ payload: LocationUpdatePayload) {
        if let idx = friendPresences.firstIndex(where: { $0.userId == payload.userId }) {
            friendPresences[idx].latitude = payload.lat
            friendPresences[idx].longitude = payload.lon
            friendPresences[idx].roughAreaLatitude = payload.roughAreaLat
            friendPresences[idx].roughAreaLongitude = payload.roughAreaLon
            friendPresences[idx].visibility = payload.visibility
            friendPresences[idx].presenceState = payload.visibility == "hidden" ? "hidden" : "live"
            friendPresences[idx].sessionId = payload.sessionId
            friendPresences[idx].lastSeenAt = Date()
        }
    }

    private func applyScoreUpdate(_ payload: ScoreUpdatePayload) {
        if let idx = friendPresences.firstIndex(where: { $0.userId == payload.userId }) {
            friendPresences[idx].drunknessCategory = payload.tipsinessCategory
            friendPresences[idx].drunknessPercentage = payload.percentage
        }
    }

    private func applyFriendStatus(_ payload: FriendStatusPayload) {
        if let idx = friendPresences.firstIndex(where: { $0.userId == payload.userId }) {
            friendPresences[idx].joinStatus = payload.joinStatus
            friendPresences[idx].presenceState = payload.presenceState
        }
    }
}
