import SwiftUI

struct AccountSetupView: View {
    let next: () -> Void
    @EnvironmentObject private var appState: AppState

    @State private var username = ""
    @State private var displayName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var errorMessage: String?

    private var isValid: Bool {
        !username.isEmpty && !displayName.isEmpty &&
        password.count >= 8 && password == confirmPassword
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                OnboardingHeader(
                    icon: "person.crop.circle.fill",
                    title: "Create your account",
                    subtitle: "Choose a username — this is how friends will find you."
                )

                VStack(spacing: 14) {
                    OnboardingTextField("Username", text: $username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    OnboardingTextField("Display name", text: $displayName)

                    OnboardingTextField("Password (8+ characters)", text: $password, isSecure: true)

                    OnboardingTextField("Confirm password", text: $confirmPassword, isSecure: true)
                }
                .padding(.horizontal, 24)

                if let error = errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(Color.antidotteDanger)
                        .padding(.horizontal, 24)
                }

                OnboardingContinueButton(label: "Create account", isLoading: isLoading, isEnabled: isValid) {
                    register()
                }
            }
            .padding(.bottom, 40)
        }
        .background(Color.antidotteBackground.ignoresSafeArea())
    }

    private func register() {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                let response = try await APIClient.shared.register(
                    username: username,
                    displayName: displayName,
                    password: password
                )
                await MainActor.run {
                    appState.setAuthenticated(
                        userId: response.userId,
                        accessToken: response.accessToken,
                        refreshToken: response.refreshToken
                    )
                    next()
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Could not create account. Username may already be taken."
                    isLoading = false
                }
            }
        }
    }
}
