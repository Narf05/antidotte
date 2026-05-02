import Foundation

final class AuthManager {
    static let shared = AuthManager()
    private init() {}

    // MARK: - Token accessors

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

    // MARK: - Token expiry check

    /// Decodes the JWT payload without verifying the signature (verification is server-side).
    /// Returns true if the token is missing or expires within the next 60 seconds.
    var accessTokenNeedsRefresh: Bool {
        guard let token = accessToken else { return true }
        guard let expiry = jwtExpiry(token) else { return true }
        return expiry.timeIntervalSinceNow < 60
    }

    private func jwtExpiry(_ token: String) -> Date? {
        let parts = token.split(separator: ".")
        guard parts.count == 3 else { return nil }

        // JWT payload is base64url-encoded — pad to a multiple of 4
        var base64 = String(parts[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let remainder = base64.count % 4
        if remainder != 0 { base64 += String(repeating: "=", count: 4 - remainder) }

        guard let data = Data(base64Encoded: base64),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let exp = json["exp"] as? TimeInterval else { return nil }
        return Date(timeIntervalSince1970: exp)
    }
}