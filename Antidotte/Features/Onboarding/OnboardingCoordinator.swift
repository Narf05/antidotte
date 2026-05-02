import SwiftUI

enum OnboardingStep: Int, CaseIterable {
    case welcome
    case ageGate
    case accountSetup
    case calibration
    case drinkUnit
    case privacyOverview
    case locationPermission
    case drunknessVisibility
    case appearance
    case passiveSignals
    case photoLogging
    case friendsSetup
    case notifications
    case ready
}

struct OnboardingCoordinator: View {
    @State private var step: OnboardingStep = .welcome

    var body: some View {
        switch step {
        case .welcome:            WelcomeView(next: advance)
        case .ageGate:            AgeGateView(next: advance)
        case .accountSetup:       AccountSetupView(next: advance)
        case .calibration:        CalibrationView(next: advance)
        case .drinkUnit:          DrinkUnitView(next: advance)
        case .privacyOverview:    PrivacyOverviewView(next: advance)
        case .locationPermission: LocationPermissionView(next: advance)
        case .drunknessVisibility:DrunknessVisibilityView(next: advance)
        case .appearance:         AppearanceView(next: advance)
        case .passiveSignals:     PassiveSignalsView(next: advance)
        case .photoLogging:       PhotoLoggingView(next: advance)
        case .friendsSetup:       FriendsSetupView(next: advance)
        case .notifications:      NotificationsView(next: advance)
        case .ready:              ReadyView()
        }
    }

    private func advance() {
        guard let next = OnboardingStep(rawValue: step.rawValue + 1) else { return }
        step = next
    }
}
