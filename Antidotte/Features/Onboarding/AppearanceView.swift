import SwiftUI

struct AppearanceView: View {
    let next: () -> Void

    @State private var styleMode: AntidotteStyleMode = .chaos
    @State private var animationsEnabled = true

    var body: some View {
        VStack(spacing: 0) {
            OnboardingHeader(
                icon: "paintpalette.fill",
                title: "Choose your look",
                subtitle: "Pick a style for your app. You can change it any time in Settings."
            )

            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 10) {
                        ForEach(AntidotteStyleMode.allCases) { mode in
                            Button { styleMode = mode } label: {
                                HStack {
                                    Circle()
                                        .fill(Color.antidotteAccent(for: mode))
                                        .frame(width: 24, height: 24)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(mode.label).font(.subheadline.weight(.medium))
                                    }
                                    Spacer()
                                    if styleMode == mode {
                                        Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.antidotteAccent)
                                    }
                                }
                                .padding(14)
                                .background(styleMode == mode ? Color.antidotteAccent.opacity(0.08) : Color.antidotteSurface)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    OnboardingToggleRow(
                        title: "Animations",
                        subtitle: "Wobbles, transitions and lively effects.",
                        isOn: $animationsEnabled
                    )
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
            }

            OnboardingContinueButton(label: "Save & continue") {
                Task {
                    try? await APIClient.shared.updateSettings([
                        "styleMode": AnyEncodable(styleMode.rawValue),
                    ])
                    await MainActor.run { next() }
                }
            }
        }
        .background(Color.antidotteBackground.ignoresSafeArea())
    }
}
