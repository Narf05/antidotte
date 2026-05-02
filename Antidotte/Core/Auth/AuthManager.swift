import Foundation

final class AuthManager {
    static let shared = AuthManager()
    private init() {}

    var accessToken: String? { Keychain.shared.read(key: "access_token") }
    var refreshToken: String? { Keychain.shared.read(key: "refresh_token") }

    func saveTokens(access: String, refresh: String) {
        Keychain.shared.save(key: "access_token", value: access)
        Keychain.shared.save(key: "refresh_token", value: refresh)
    }

    func clearTokens() {
        Keychain.shared.delete(key: "access_token")
        Keychain.shared.delete(key: "refresh_token")
    }

    // TODO: refresh token flow, auto-retry on 401
}
