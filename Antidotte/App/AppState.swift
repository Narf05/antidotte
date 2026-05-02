import Foundation
import Combine

@MainActor
final class AppState: ObservableObject {

    // MARK: - Published state

    @Published private(set) var isAuthenticated: Bool
    @Published private(set) var hasCompletedOnboarding: Bool
    @Published var selectedTab: Tab = .map
    @Published var panicPrivacyActive: Bool
    @Published private(set) var currentUserId: String?
    @Published private(set) var currentSessionId: String?

    // MARK: - Tab

    enum Tab: Hashable {
        case map, stats, test, profile
    }

    // MARK: - UserDefaults keys

    private enum Keys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let currentUserId = "currentUserId"
        static let currentSessionId = "currentSessionId"
        static let panicPrivacyActive = "panicPrivacyActive"
        static let panicPrivacyExpiresAt = "panicPrivacyExpiresAt"
    }

    // MARK: - Init

    init() {
        let defaults = UserDefaults.standard
        self.hasCompletedOnboarding = defaults.bool(forKey: Keys.hasCompletedOnboarding)
        self.currentUserId = defaults.string(forKey: Keys.currentUserId)
        self.currentSessionId = defaults.string(forKey: Keys.currentSessionId)
        self.isAuthenticated = AuthManager.shared.accessToken != nil

        // Panic privacy auto-expires after 24h
        if let expiresAt = defaults.object(forKey: Keys.panicPrivacyExpiresAt) as? Date, expiresAt > Date() {
            self.panicPrivacyActive = true
        } else {
            self.panicPrivacyActive = false
            defaults.removeObject(forKey: Keys.panicPrivacyActive)
            defaults.removeObject(forKey: Keys.panicPrivacyExpiresAt)
        }
    }

    // MARK: - Auth

    func setAuthenticated(userId: String, accessToken: String, refreshToken: String) {
        AuthManager.shared.saveTokens(access: accessToken, refresh: refreshToken)
        UserDefaults.standard.set(userId, forKey: Keys.currentUserId)
        currentUserId = userId
        isAuthenticated = true
    }

    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: Keys.hasCompletedOnboarding)
        hasCompletedOnboarding = true
    }

    func signOut() {
        AuthManager.shared.clearTokens()
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: Keys.currentUserId)
        defaults.removeObject(forKey: Keys.currentSessionId)
        defaults.removeObject(forKey: Keys.hasCompletedOnboarding)
        defaults.removeObject(forKey: Keys.panicPrivacyActive)
        defaults.removeObject(forKey: Keys.panicPrivacyExpiresAt)
        currentUserId = nil
        currentSessionId = nil
        panicPrivacyActive = false
        isAuthenticated = false
        hasCompletedOnboarding = false
        selectedTab = .map
    }

    // MARK: - Session

    func startSession(id: String) {
        UserDefaults.standard.set(id, forKey: Keys.currentSessionId)
        currentSessionId = id
    }

    func clearSession() {
        UserDefaults.standard.removeObject(forKey: Keys.currentSessionId)
        currentSessionId = nil
    }

    // MARK: - Panic privacy

    func activatePanicPrivacy() {
        let expiresAt = Date().addingTimeInterval(24 * 60 * 60)
        UserDefaults.standard.set(true, forKey: Keys.panicPrivacyActive)
        UserDefaults.standard.set(expiresAt, forKey: Keys.panicPrivacyExpiresAt)
        panicPrivacyActive = true
        // TODO: PATCH /users/me/settings { panic_privacy_active: true }
        // WebSocket will push hidden presence to all friends
    }

    func deactivatePanicPrivacy() {
        UserDefaults.standard.removeObject(forKey: Keys.panicPrivacyActive)
        UserDefaults.standard.removeObject(forKey: Keys.panicPrivacyExpiresAt)
        panicPrivacyActive = false
        // TODO: PATCH /users/me/settings { panic_privacy_active: false }
    }

    // MARK: - Scene phase

    func handleBackground() {
        // TODO: reduce LocationManager update frequency if session active
        // TODO: flush pending SyncQueue items
    }

    func handleForeground() {
        // TODO: resume LocationManager updates
        // TODO: check if panic privacy has expired
        // TODO: re-connect WebSocketClient if disconnected
        checkPanicPrivacyExpiry()
    }

    // MARK: - Private

    private func checkPanicPrivacyExpiry() {
        guard panicPrivacyActive else { return }
        let defaults = UserDefaults.standard
        if let expiresAt = defaults.object(forKey: Keys.panicPrivacyExpiresAt) as? Date, expiresAt <= Date() {
            deactivatePanicPrivacy()
        }
    }
}