import Foundation
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var hasCompletedOnboarding: Bool = false
    @Published var currentSession: NightOutSession? = nil
    @Published var panicPrivacyActive: Bool = false
}
