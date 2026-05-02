import Foundation

struct PrivacyGate {
    private init() {}

    static func canCollectLocation(for user: User?) -> Bool {
        guard let user else { return false }
        return user.locationSharingEnabled && !user.panicPrivacyActive
    }

    static func canShareExactLocation(for user: User?) -> Bool {
        guard canCollectLocation(for: user), let user else { return false }
        return user.locationPrecision == VisibilityLevel.exact.rawValue
    }

    static func canCollectBackgroundLocation(for user: User?) -> Bool {
        guard canCollectLocation(for: user), let user else { return false }
        return user.shareWhenAppClosed
    }

    static func canCollectMotion(for user: User?) -> Bool {
        guard let user else { return false }
        return user.motionTrackingEnabled && !user.panicPrivacyActive
    }

    static func canCollectPhoneUsage(for user: User?) -> Bool {
        guard let user else { return false }
        return user.phoneUsageTrackingEnabled && !user.panicPrivacyActive
    }

    static func canCollectVoice(for user: User?) -> Bool {
        guard let user else { return false }
        return user.voiceAnalysisEnabled
    }

    static func canAnalyzeRefreshmentPhotos(for user: User?) -> Bool {
        guard let user else { return false }
        return user.photoRefreshmentDetectionEnabled
    }

    static func canSaveRefreshmentPhotos(for user: User?) -> Bool {
        guard let user else { return false }
        return user.photoRefreshmentDetectionEnabled && user.saveRefreshmentPhotosEnabled
    }

    static func canShareScore(for user: User?) -> Bool {
        guard let user else { return false }
        return user.scoreSharingEnabled && !user.panicPrivacyActive
    }

    static func shouldSuggestActiveTest(confidence: Double, threshold: Double = 45) -> Bool {
        confidence < threshold
    }

    static func panicPrivacyIsExpired(for user: User?, now: Date = Date()) -> Bool {
        guard let user, user.panicPrivacyActive, let expiry = user.panicPrivacyExpiresAt else {
            return false
        }
        return expiry <= now
    }

    // Backward-compatible placeholders for older call sites that do not pass a user.
    static func canCollectLocation() -> Bool { false }
    static func canCollectMotion() -> Bool { false }
    static func canCollectPhoneUsage() -> Bool { false }
    static func canCollectVoice() -> Bool { false }
    static func canSaveDrinkPhotos() -> Bool { false }
}
