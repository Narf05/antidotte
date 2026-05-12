import SwiftUI

struct PhotoLoggingView: View {
    let next: () -> Void

    @State private var photoDetectionEnabled = false
    @State private var savePhotosEnabled = false

    var body: some View {
        VStack(spacing: 0) {
            OnboardingHeader(
                icon: "camera.fill",
                title: "Photo-assisted logging",
                subtitle: "Point your camera at a drink and Antidotte can pre-fill the details for you."
            )

            ScrollView {
                VStack(spacing: 12) {
                    OnboardingToggleRow(
                        title: "Enable photo detection",
                        subtitle: "Adds an optional camera shortcut to the +1 button. Off by default.",
                        isOn: $photoDetectionEnabled
                    )

                    if photoDetectionEnabled {
                        OnboardingToggleRow(
                            title: "Save photos after analysis",
                            subtitle: "If off, photos are deleted immediately after analysis.",
                            isOn: $savePhotosEnabled
                        )
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Label("Photos are never shared with friends", systemImage: "person.slash.fill")
                        Label("You always review before saving the drink", systemImage: "checkmark.circle.fill")
                        Label("You can change this in Settings", systemImage: "gear")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
            }

            OnboardingContinueButton(label: "Save & continue") {
                Task {
                    try? await APIClient.shared.updateSettings([
                        "photoDetectionEnabled": AnyEncodable(photoDetectionEnabled),
                        "savePhotosEnabled": AnyEncodable(savePhotosEnabled),
                    ])
                    await MainActor.run { next() }
                }
            }
        }
        .background(Color.antidotteBackground.ignoresSafeArea())
    }
}
