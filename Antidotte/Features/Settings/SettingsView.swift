import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        // Sections: 0-Panic Privacy, 1-Account, 2-Appearance, 3-Privacy & Safety,
        //           4-Location, 5-Score & Calibration, 6-+1 Drink Unit,
        //           7-Photo Logging, 8-Friends & Groups, 9-Notifications,
        //           10-Language, 11-Data Export & Deletion, 12-About
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                PanicPrivacyBanner()
                // TODO: render each settings section
            }
        }
    }
}
