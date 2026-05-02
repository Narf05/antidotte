import SwiftUI

struct PassiveSignalsView: View {
    let next: () -> Void

    @State private var motionEnabled = false
    @State private var phoneUsageEnabled = false
    @State private var voiceEnabled = false

    var body: some View {
        VStack(spacing: 0) {
            OnboardingHeader(
                icon: "sensor.tag.radiowaves.forward.fill",
                title: "Passive signals",
                subtitle: "Optional extras that improve score accuracy. All off by default — you choose."
            )

            ScrollView {
                VStack(spacing: 12) {
                    OnboardingToggleRow(
                        title: "Motion tracking",
                        subtitle: "Uses accelerometer to detect gait and balance changes. Only derived summaries are stored.",
                        isOn: $motionEnabled
                    )
                    OnboardingToggleRow(
                        title: "Phone usage patterns",
                        subtitle: "Tracks typing rhythm and tap accuracy — not content. Only derived metrics are stored.",
                        isOn: $phoneUsageEnabled
                    )
                    OnboardingToggleRow(
                        title: "Voice analysis",
                        subtitle: "Optional during active tests only. Not recorded continuously.",
                        isOn: $voiceEnabled
                    )

                    Text("Raw sensor data is never stored or sent to the server. Only derived scores are uploaded.")
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
                        "motionTrackingEnabled": AnyEncodable(motionEnabled),
                        "phoneUsageTrackingEnabled": AnyEncodable(phoneUsageEnabled),
                        "voiceAnalysisEnabled": AnyEncodable(voiceEnabled),
                    ])
                    await MainActor.run { next() }
                }
            }
        }
        .background(Color.antidotteBackground.ignoresSafeArea())
    }
}
