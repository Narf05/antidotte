import Foundation

struct PrivacyGate {
    static func canCollectLocation() -> Bool {
        // TODO: read privacy_settings.location_sharing_enabled
        return false
    }

    static func canCollectMotion() -> Bool {
        // TODO: read privacy_settings.motion_tracking_enabled
        return false
    }

    static func canCollectPhoneUsage() -> Bool {
        // TODO: read privacy_settings.phone_usage_tracking_enabled
        return false
    }

    static func canCollectVoice() -> Bool {
        // TODO: read privacy_settings.voice_analysis_enabled
        return false
    }

    static func canSaveDrinkPhotos() -> Bool {
        // TODO: read privacy_settings.save_drink_photos_enabled
        return false
    }
}
