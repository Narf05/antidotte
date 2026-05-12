import Foundation

enum APIError: Error {
    case invalidURL
    case unauthorized
    case httpError(Int, Data)
    case decoding(Error)
    case network(Error)
}

final class APIClient {
    static let shared = APIClient()

    private let baseURL: String
    private let session: URLSession

    private init() {
        self.baseURL = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String
            ?? "http://localhost:3000"
        self.session = URLSession.shared
    }

    // MARK: - Generic request

    @discardableResult
    func request<T: Decodable>(
        _ endpoint: Endpoint,
        body: Encodable? = nil,
        responseType: T.Type = EmptyResponse.self
    ) async throws -> T {
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw APIError.invalidURL
        }

        var req = URLRequest(url: url)
        req.httpMethod = endpoint.method
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body {
            req.httpBody = try JSONEncoder.api.encode(body)
        }

        if let token = AuthManager.shared.accessToken {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        do {
            let (data, response) = try await session.data(for: req)
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0

            if status == 401 {
                let refreshed = try? await refreshAccessToken()
                if refreshed == true {
                    return try await request(endpoint, body: body, responseType: responseType)
                }
                throw APIError.unauthorized
            }

            guard (200..<300).contains(status) else {
                throw APIError.httpError(status, data)
            }

            if T.self == EmptyResponse.self {
                return EmptyResponse() as! T
            }
            do {
                return try JSONDecoder.api.decode(T.self, from: data)
            } catch {
                throw APIError.decoding(error)
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.network(error)
        }
    }

    // MARK: - Auth helpers

    func register(username: String, displayName: String, password: String) async throws -> AuthResponse {
        try await request(.register, body: ["username": username, "displayName": displayName, "password": password], responseType: AuthResponse.self)
    }

    func login(username: String, password: String) async throws -> AuthResponse {
        try await request(.login, body: ["username": username, "password": password], responseType: AuthResponse.self)
    }

    @discardableResult
    private func refreshAccessToken() async throws -> Bool {
        guard let refresh = AuthManager.shared.refreshToken else { return false }
        struct RefreshResponse: Decodable { let accessToken: String }
        let resp = try await request(.refreshToken, body: ["refreshToken": refresh], responseType: RefreshResponse.self)
        AuthManager.shared.saveTokens(access: resp.accessToken, refresh: refresh)
        return true
    }

    // MARK: - Convenience wrappers

    func getProfile() async throws -> [String: AnyDecodable] {
        try await request(.profile, responseType: [String: AnyDecodable].self)
    }

    func updateSettings(_ settings: [String: AnyEncodable]) async throws {
        try await request(.settings, body: settings)
    }

    func logDrink(_ body: [String: AnyEncodable]) async throws -> LogDrinkResponse {
        try await request(.logDrink, body: body, responseType: LogDrinkResponse.self)
    }

    func startSession(title: String, theme: String? = nil) async throws -> SessionResponse {
        var body: [String: AnyEncodable] = ["title": AnyEncodable(title)]
        if let theme { body["theme"] = AnyEncodable(theme) }
        return try await request(.createSession, body: body, responseType: SessionResponse.self)
    }

    func endSession(id: String) async throws {
        try await request(.endSession(sessionId: id))
    }

    func updatePresence(lat: Double, lon: Double, accuracyM: Double) async throws {
        try await request(.updatePresence, body: ["lat": lat, "lon": lon, "accuracyM": accuracyM])
    }

    func getFriendPresences() async throws -> [FriendPresenceDTO] {
        try await request(.friendPresences, responseType: [FriendPresenceDTO].self)
    }

    func submitActiveTest(_ result: ActiveTestSubmission) async throws -> ScoreSnapshot {
        try await request(.submitActiveTest, body: result, responseType: ScoreSnapshot.self)
    }

    func getCurrentScore() async throws -> ScoreSnapshot {
        try await request(.currentScore, responseType: ScoreSnapshot.self)
    }
}

// MARK: - Response types

struct EmptyResponse: Decodable {}

struct AuthResponse: Decodable {
    let userId: String
    let accessToken: String
    let refreshToken: String
}

struct LogDrinkResponse: Decodable {
    let logId: String
}

struct SessionResponse: Decodable {
    let sessionId: String
}

struct FriendPresenceDTO: Decodable {
    let userId: String
    let displayName: String
    let profileImageUrl: String?
    let visibility: String
    let presenceState: String
    let lat: Double?
    let lon: Double?
    let roughAreaLat: Double?
    let roughAreaLon: Double?
    let lastSeenAt: String?
    let sessionId: String?
    let joinStatus: String?
}

struct ScoreSnapshot: Decodable {
    let percentage: Double
    let confidence: Double
    let tipsinessCategory: String
}

struct ActiveTestSubmission: Encodable {
    let gameType: String
    let rawScore: Double
    let normalizedScore: Double
    let confidence: Double
    let roundType: String
    let sessionId: String?
}

// MARK: - Coding helpers

extension JSONEncoder {
    static let api: JSONEncoder = {
        let e = JSONEncoder()
        e.keyEncodingStrategy = .convertToSnakeCase
        return e
    }()
}

extension JSONDecoder {
    static let api: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()
}

// Type-erased Encodable/Decodable for dynamic dictionaries
struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    init<T: Encodable>(_ value: T) { _encode = { try value.encode(to: $0) } }
    func encode(to encoder: Encoder) throws { try _encode(encoder) }
}

struct AnyDecodable: Decodable {
    let value: Any
    init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if let v = try? c.decode(Bool.self)   { value = v; return }
        if let v = try? c.decode(Int.self)    { value = v; return }
        if let v = try? c.decode(Double.self) { value = v; return }
        if let v = try? c.decode(String.self) { value = v; return }
        value = NSNull()
    }
}
