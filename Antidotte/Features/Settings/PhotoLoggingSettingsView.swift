import SwiftUI

struct PhotoLoggingSettingsView: View {
    @State private var photoDetectionEnabled = false
    @State private var savePhotosEnabled = false
    @State private var defaultFlow: String = "ask"
    @State private var isSaving = false

    private let flowOptions = [
        ("quick", "Quick add", "Log instantly without a photo"),
        ("photo", "Photo first", "Always prompt for a photo"),
        ("ask",   "Ask each time", "Choose at logging time"),
    ]

    var body: some View {
        List {
            Section {
                Toggle("Photo drink detection", isOn: $photoDetectionEnabled)
                    .tint(Color.antidotteAccent)
            } footer: {
                Text("Uses on-device ML to identify drinks from camera photos. Photos are never uploaded.")
            }

            Section {
                Toggle("Save photos to library", isOn: $savePhotosEnabled)
                    .tint(Color.antidotteAccent)
                    .disabled(!photoDetectionEnabled)
            } footer: {
                Text("Saves drink photos to your photo library.")
            }

            Section("Default logging flow") {
                ForEach(flowOptions, id: \.0) { id, label, detail in
                    Button { defaultFlow = id } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(label).font(.subheadline).foregroundStyle(.primary)
                                Text(detail).font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            if defaultFlow == id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(Color.antidotteAccent)
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
        .navigationTitle("Photo logging")
        .navigationBarTitleDisplayMode(.inline)
        .task { await load() }
    }

    private func load() async {
        let profile = try? await APIClient.shared.getProfile()
        photoDetectionEnabled = profile?["photo_detection_enabled"]?.value as? Bool ?? false
        savePhotosEnabled = profile?["save_photos_to_library"]?.value as? Bool ?? false
        defaultFlow = profile?["default_log_flow"]?.value as? String ?? "ask"
    }

    private func save() async {
        isSaving = true
        try? await APIClient.shared.updateSettings([
            "photoDetectionEnabled": AnyEncodable(photoDetectionEnabled),
            "savePhotosToLibrary": AnyEncodable(savePhotosEnabled),
            "defaultLogFlow": AnyEncodable(defaultFlow),
        ])
        isSaving = false
    }
}
