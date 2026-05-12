import SwiftUI
import UserNotifications

struct NotificationSettingsView: View {
    @State private var notificationsEnabled = true
    @State private var friendStartsDrinking = true
    @State private var nearbyFriend = true
    @State private var sessionReminders = true
    @State private var permissionDenied = false
    @State private var isSaving = false

    var body: some View {
        List {
            if permissionDenied {
                Section {
                    HStack(spacing: 12) {
                        Image(systemName: "bell.slash.fill")
                            .foregroundStyle(.orange)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Notifications disabled")
                                .font(.subheadline.weight(.medium))
                            Text("Enable in Settings to receive alerts.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button("Settings") {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.antidotteAccent)
                    }
                }
            }

            Section {
                Toggle("Push notifications", isOn: $notificationsEnabled)
                    .tint(Color.antidotteAccent)
                    .disabled(permissionDenied)
            }

            if notificationsEnabled && !permissionDenied {
                Section("Alerts") {
                    Toggle("Friend starts drinking", isOn: $friendStartsDrinking)
                        .tint(Color.antidotteAccent)
                    Toggle("Friend is nearby", isOn: $nearbyFriend)
                        .tint(Color.antidotteAccent)
                    Toggle("Session reminders", isOn: $sessionReminders)
                        .tint(Color.antidotteAccent)
                }
            }

            Section {
                Button {
                    Task { await save() }
                } label: {
                    HStack {
                        Text("Save")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                        if isSaving { ProgressView() }
                    }
                }
                .disabled(isSaving || permissionDenied)
                .foregroundStyle(Color.antidotteAccent)
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .task { await checkPermission(); await load() }
    }

    private func checkPermission() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        permissionDenied = settings.authorizationStatus == .denied
    }

    private func load() async {
        let profile = try? await APIClient.shared.getProfile()
        notificationsEnabled = profile?["notifications_enabled"]?.value as? Bool ?? true
    }

    private func save() async {
        isSaving = true
        try? await APIClient.shared.updateSettings([
            "notificationsEnabled": AnyEncodable(notificationsEnabled),
            "notifyFriendStartsDrinking": AnyEncodable(friendStartsDrinking),
            "notifyNearbyFriend": AnyEncodable(nearbyFriend),
            "notifySessionReminders": AnyEncodable(sessionReminders),
        ])
        isSaving = false
    }
}
