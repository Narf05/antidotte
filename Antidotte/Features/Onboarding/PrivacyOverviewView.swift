import SwiftUI

private struct PrivacyPoint: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let detail: String
}

private let points: [PrivacyPoint] = [
    PrivacyPoint(icon: "mappin.slash", title: "Location is off by default", detail: "You enable it if and when you want. Friends only see what you allow."),
    PrivacyPoint(icon: "eye.slash.fill", title: "Panic privacy", detail: "One tap hides your location and score from everyone for 24 hours."),
    PrivacyPoint(icon: "chart.bar.fill", title: "Score stays private", detail: "You control whether friends see a category, a number, or nothing."),
    PrivacyPoint(icon: "person.crop.circle.badge.xmark", title: "Calibration data is private", detail: "Your weight, height, and tolerance are never shared."),
    PrivacyPoint(icon: "arrow.triangle.2.circlepath", title: "You can change anything", detail: "All choices made during setup can be updated in Settings at any time."),
]

struct PrivacyOverviewView: View {
    let next: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            OnboardingHeader(
                icon: "lock.shield.fill",
                title: "Your privacy, your control",
                subtitle: "Here's how Antidotte protects you."
            )

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(points) { point in
                        HStack(alignment: .top, spacing: 14) {
                            Image(systemName: point.icon)
                                .font(.title3)
                                .foregroundStyle(Color.antidotteAccent)
                                .frame(width: 32)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(point.title).font(.subheadline.weight(.semibold))
                                Text(point.detail).font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                        .padding(14)
                        .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
            }

            OnboardingContinueButton(label: "Got it") { next() }
        }
        .background(Color.antidotteBackground.ignoresSafeArea())
    }
}
