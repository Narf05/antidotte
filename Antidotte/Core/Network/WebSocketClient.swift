import Foundation
import Combine

enum WSEvent: Decodable {
    case locationUpdate(LocationUpdatePayload)
    case scoreUpdate(ScoreUpdatePayload)
    case friendStatus(FriendStatusPayload)
    case sessionEvent(SessionPayload)
    case connected
    case pong
    case unknown

    private enum CodingKeys: String, CodingKey { case type }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let type = try c.decode(String.self, forKey: .type)
        let root = try decoder.singleValueContainer()
        switch type {
        case "location_update":   self = .locationUpdate(try root.decode(LocationUpdatePayload.self))
        case "score_update":      self = .scoreUpdate(try root.decode(ScoreUpdatePayload.self))
        case "friend_status":     self = .friendStatus(try root.decode(FriendStatusPayload.self))
        case "session_started", "session_ended": self = .sessionEvent(try root.decode(SessionPayload.self))
        case "connected":         self = .connected
        case "pong":              self = .pong
        default:                  self = .unknown
        }
    }
}

struct LocationUpdatePayload: Decodable {
    let userId: String
    let visibility: String
    let lat: Double?
    let lon: Double?
    let roughAreaLat: Double?
    let roughAreaLon: Double?
    let lastSeenAt: String
    let sessionId: String?
}

struct ScoreUpdatePayload: Decodable {
    let userId: String
    let tipsinessCategory: String
    let percentage: Double?
    let lastUpdatedAt: String
}

struct FriendStatusPayload: Decodable {
    let userId: String
    let joinStatus: String
    let presenceState: String
}

struct SessionPayload: Decodable {
    let type: String
    let userId: String
    let sessionId: String
    let sessionTitle: String?
}

@MainActor
final class WebSocketClient: ObservableObject {
    static let shared = WebSocketClient()

    @Published private(set) var isConnected = false

    let events = PassthroughSubject<WSEvent, Never>()

    private var task: URLSessionWebSocketTask?
    private var pingTimer: Timer?
    private var reconnectTask: Task<Void, Never>?
    private let baseURL: String

    private init() {
        self.baseURL = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String
            ?? "http://localhost:3000"
    }

    func connect() {
        guard let token = AuthManager.shared.accessToken else { return }
        let wsURL = baseURL
            .replacingOccurrences(of: "http://", with: "ws://")
            .replacingOccurrences(of: "https://", with: "wss://")

        guard let url = URL(string: "\(wsURL)/ws?token=\(token)") else { return }

        task?.cancel()
        task = URLSession.shared.webSocketTask(with: url)
        task?.resume()
        isConnected = true

        schedulePing()
        receive()
    }

    func disconnect() {
        pingTimer?.invalidate()
        pingTimer = nil
        reconnectTask?.cancel()
        task?.cancel(with: .normalClosure, reason: nil)
        task = nil
        isConnected = false
    }

    // MARK: - Private

    private func receive() {
        task?.receive { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    if let data = text.data(using: .utf8),
                       let event = try? JSONDecoder.api.decode(WSEvent.self, from: data) {
                        Task { @MainActor in self.events.send(event) }
                    }
                case .data(let data):
                    if let event = try? JSONDecoder.api.decode(WSEvent.self, from: data) {
                        Task { @MainActor in self.events.send(event) }
                    }
                @unknown default: break
                }
                self.receive()
            case .failure:
                Task { @MainActor in
                    self.isConnected = false
                    self.scheduleReconnect()
                }
            }
        }
    }

    private func schedulePing() {
        pingTimer?.invalidate()
        pingTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.task?.send(.string(#"{"type":"ping"}"#)) { _ in }
        }
    }

    private func scheduleReconnect() {
        reconnectTask?.cancel()
        reconnectTask = Task {
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            if !Task.isCancelled { self.connect() }
        }
    }
}
