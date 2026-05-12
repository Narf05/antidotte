import SwiftUI

struct LocationSettingsView: View {
    @State private var locationEnabled = true
    @State private var backgroundLocation = false
    @State private var precision: LocationPrecision = .approximate150m
    @State private var isSaving = false

    var body: some View {
        List {
            Section {
                Toggle("Share location", isOn: $locationEnabled)
                    .tint(Color.antidotteAccent)
            } footer: {
                Text("When off, friends see you as offline and your location is never sent.")
            }

            if locationEnabled {
                Section("Precision") {
                    precisionRow(.exact, label: "Exact", detail: "Friends see your street address")
                    precisionRow(.approximate150m, label: "Approximate (~150 m)", detail: "Neighborhood level")
                    precisionRow(.off, label: "Hidden", detail: "Area label only, no coordinates")
                }

                Section {
                    Toggle("Background location", isOn: $backgroundLocation)
                        .tint(Color.antidotteAccent)
                } footer: {
                    Text("Keeps your position updated while the app is in the background. Uses more battery.")
                }

                Section {
                    NavigationLink("Per-group rules") {
                        LocationGroupsView()
                    }
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
        .navigationTitle("Location")
        .navigationBarTitleDisplayMode(.inline)
        .task { await load() }
    }

    @ViewBuilder
    private func precisionRow(_ p: LocationPrecision, label: String, detail: String) -> some View {
        Button { precision = p } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(label).font(.subheadline).foregroundStyle(.primary)
                    Text(detail).font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                if precision == p {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.antidotteAccent)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private func load() async {
        let profile = try? await APIClient.shared.getProfile()
        locationEnabled = profile?["location_sharing_enabled"]?.value as? Bool ?? true
        let raw = profile?["location_precision"]?.value as? String ?? "rough_area"
        switch raw {
        case "exact":      precision = .exact
        case "rough_area": precision = .approximate150m
        default:           precision = .off
        }
    }

    private func save() async {
        isSaving = true
        let modeValue: String
        switch precision {
        case .exact:           modeValue = "exact"
        case .approximate150m: modeValue = "rough_area"
        case .off:             modeValue = "off"
        }
        try? await APIClient.shared.updateSettings([
            "locationSharingEnabled": AnyEncodable(locationEnabled),
            "locationPrecision": AnyEncodable(modeValue),
        ])
        isSaving = false
    }
}
