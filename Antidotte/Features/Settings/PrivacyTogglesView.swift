import SwiftUI

struct PrivacyTogglesView: View {
    @State private var locationEnabled = true
    @State private var drunknessVisibility: String = "category"
    @State private var motionEnabled = true
    @State private var phoneUsageEnabled = true
    @State private var voiceEnabled = false
    @State private var isSaving = false

    private let visibilityOptions = [
        ("category",   "Category only",  "e.g. Buzzing"),
        ("percentage", "Percentage only", "e.g. 42%"),
        ("both",       "Both",           "Buzzing · 42%"),
        ("hidden",     "Hidden",         "—"),
    ]

    var body: some View {
        List {
            Section("Signals") {
                Toggle("Location sharing", isOn: $locationEnabled).tint(Color.antidotteAccent)
                Toggle("Motion tracking", isOn: $motionEnabled).tint(Color.antidotteAccent)
                Toggle("Phone usage tracking", isOn: $phoneUsageEnabled).tint(Color.antidotteAccent)
                Toggle("Voice analysis", isOn: $voiceEnabled).tint(Color.antidotteAccent)
            }

            Section("Drunkness visibility") {
                ForEach(visibilityOptions, id: \.0) { id, label, example in
                    Button { drunknessVisibility = id } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(label).font(.subheadline).foregroundStyle(.primary)
                                Text(example).font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            if drunknessVisibility == id {
                                Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.antidotteAccent)
                            }
                        }
                    }
                    .buttonStyle(.plain)
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
                .disabled(isSaving)
                .foregroundStyle(Color.antidotteAccent)
            }
        }
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
        .task { await load() }
    }

    private func load() async {
        let profile = try? await APIClient.shared.getProfile()
        locationEnabled = profile?["location_sharing_enabled"]?.value as? Bool ?? true
        drunknessVisibility = profile?["drunkness_visibility"]?.value as? String ?? "category"
        motionEnabled = profile?["motion_tracking_enabled"]?.value as? Bool ?? true
        phoneUsageEnabled = profile?["phone_usage_tracking_enabled"]?.value as? Bool ?? true
        voiceEnabled = profile?["voice_analysis_enabled"]?.value as? Bool ?? false
    }

    private func save() async {
        isSaving = true
        try? await APIClient.shared.updateSettings([
            "locationSharingEnabled": AnyEncodable(locationEnabled),
            "drunknessVisibility": AnyEncodable(drunknessVisibility),
            "motionTrackingEnabled": AnyEncodable(motionEnabled),
            "phoneUsageTrackingEnabled": AnyEncodable(phoneUsageEnabled),
            "voiceAnalysisEnabled": AnyEncodable(voiceEnabled),
        ])
        isSaving = false
    }
}
