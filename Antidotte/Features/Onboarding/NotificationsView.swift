import SwiftUI
import UserNotifications

struct NotificationsView: View {
    let next: () -> Void

    @State private var permissionGranted = false
    @State private var checked = false

    var body: some View {
        VStack(spacing: 0) {
            OnboardingHeader(
                icon: "bell.fill",
                title: "Stay in the loop",
                subtitle: "Get notified when friends start a session, accept your request, or are nearby."
            )

            Spacer()

            VStack(spacing: 16) {
                notificationRow(icon: "person.2.fill",  text: "Friend joins a night out")
                notificationRow(icon: "checkmark.seal.fill", text: "Friend request accepted")
                notificationRow(icon: "location.fill",  text: "A friend is nearby (opt-in per friend)")
            }
            .padding(.horizontal, 24)

            Spacer()

            VStack(spacing: 12) {
                OnboardingContinueButton(label: "Enable notifications") {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                        DispatchQueue.main.async { next() }
                    }
                }

                Button("Skip") { next() }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 40)
            }
        }
        .background(Color.antidotteBackground.ignoresSafeArea())
    }

    private func notificationRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color.antidotteAccent)
                .frame(width: 32)
            Text(text)
                .font(.subheadline)
            Spacer()
        }
        .padding(14)
        .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 12))
    }
}
