import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    PanicPrivacyBanner()
                        .padding(.horizontal, 20)

                    settingsSection("Privacy & Safety") {
                        Toggle("Location sharing", isOn: $viewModel.locationEnabled)
                        Picker("Score visibility", selection: $viewModel.drunknessVisibility) {
                            Text("Category only").tag("category")
                            Text("Percentage only").tag("percentage")
                            Text("Both").tag("both")
                            Text("Hidden").tag("hidden")
                        }
                        Toggle("Motion tracking", isOn: $viewModel.motionEnabled)
                        Toggle("Phone usage tracking", isOn: $viewModel.phoneUsageEnabled)
                        Toggle("Voice analysis", isOn: $viewModel.voiceAnalysisEnabled)
                    }

                    settingsSection("Appearance") {
                        Picker("Style", selection: $viewModel.styleMode) {
                            ForEach(AntidotteStyleMode.allCases) { mode in
                                Text(mode.label).tag(mode.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                        Toggle("Animations", isOn: $viewModel.animationsEnabled)
                    }

                    settingsSection("Notifications") {
                        Toggle("Enable notifications", isOn: $viewModel.notificationsEnabled)
                    }

                    settingsSection("Account") {
                        Button(role: .destructive) {
                            appState.signOut()
                            dismiss()
                        } label: {
                            Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right")
                                .foregroundStyle(Color.antidotteDanger)
                        }
                    }

                    settingsSection("About") {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.vertical, 16)
            }
            .background(Color.antidotteBackground.ignoresSafeArea())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") { viewModel.save(); dismiss() }
                        .font(.subheadline.weight(.semibold))
                }
            }
        }
        .onAppear { viewModel.load() }
    }

    @ViewBuilder
    private func settingsSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 20)
                .padding(.bottom, 8)

            VStack(spacing: 0) {
                content()
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
            }
            .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 20)
        }
    }
}
