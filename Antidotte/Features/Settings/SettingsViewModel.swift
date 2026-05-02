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

    func togglePanicPrivacy() {
        panicPrivacyActive.toggle()
        // TODO: PATCH /users/settings, push hidden state to all friends via WS
    }
}
