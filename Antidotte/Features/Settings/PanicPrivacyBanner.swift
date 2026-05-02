import SwiftUI

struct PanicPrivacyBanner: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        // TODO: fixed at top, prominent button to activate/deactivate panic privacy
        // When on: hide live location and score from everyone for 24h
        EmptyView()
    }
}
