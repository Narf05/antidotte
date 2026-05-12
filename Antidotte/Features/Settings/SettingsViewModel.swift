import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var panicPrivacyActive: Bool = false
    @Published var locationEnabled: Bool = false
    @Published var locationPrecision: LocationPrecision = .exact
    @Published var motionEnabled: Bool = false
    @Published var phoneUsageEnabled: Bool = false
    @Published var voiceAnalysisEnabled: Bool = false
    @Published var drunknessVisibility: String = "category"
    @Published var styleMode: String = "chaos"
    @Published var animationsEnabled: Bool = true
    @Published var language: String = "en"
    @Published var notificationsEnabled: Bool = true

    func load() {
        Task {
            let profile = try? await APIClient.shared.getProfile()
            await MainActor.run {
                styleMode = profile?["style_mode"]?.value as? String ?? "chaos"
                drunknessVisibility = profile?["drunkness_visibility"]?.value as? String ?? "category"
                locationEnabled = profile?["location_sharing_enabled"]?.value as? Bool ?? false
                motionEnabled = profile?["motion_tracking_enabled"]?.value as? Bool ?? false
                phoneUsageEnabled = profile?["phone_usage_tracking_enabled"]?.value as? Bool ?? false
                voiceAnalysisEnabled = profile?["voice_analysis_enabled"]?.value as? Bool ?? false
                notificationsEnabled = profile?["notifications_enabled"]?.value as? Bool ?? true
                panicPrivacyActive = profile?["panic_privacy_active"]?.value as? Bool ?? false
            }
        }
    }

    func togglePanicPrivacy() {
        panicPrivacyActive.toggle()
        Task {
            try? await APIClient.shared.updateSettings(["panicPrivacyActive": AnyEncodable(panicPrivacyActive)])
        }
    }

    func save() {
        Task {
            try? await APIClient.shared.updateSettings([
                "locationSharingEnabled": AnyEncodable(locationEnabled),
                "motionTrackingEnabled": AnyEncodable(motionEnabled),
                "phoneUsageTrackingEnabled": AnyEncodable(phoneUsageEnabled),
                "voiceAnalysisEnabled": AnyEncodable(voiceAnalysisEnabled),
                "drunknessVisibility": AnyEncodable(drunknessVisibility),
                "styleMode": AnyEncodable(styleMode),
                "notificationsEnabled": AnyEncodable(notificationsEnabled),
            ])
        }
    }
}
