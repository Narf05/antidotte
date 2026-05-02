import SwiftUI

struct DrinkUnitSettingsView: View {
    @State private var selectedPreset: String = "beer_pint"
    @State private var customLabel: String = ""
    @State private var volumeMl: Double = 568
    @State private var strengthPct: Double = 4.5
    @State private var isSaving = false
    @State private var saveSuccess = false

    private let presets: [(id: String, label: String, volume: Double, abv: Double)] = [
        ("beer_pint",  "Beer – Pint (568 ml)",   568, 4.5),
        ("beer_can",   "Beer – Can (330 ml)",     330, 5.0),
        ("wine",       "Wine – Glass (150 ml)",   150, 12.0),
        ("shot",       "Shot (25 ml)",             25, 40.0),
        ("cocktail",   "Cocktail (200 ml)",       200, 10.0),
        ("custom",     "Custom",                    0,  0.0),
    ]

    var body: some View {
        List {
            Section("Preset") {
                ForEach(presets, id: \.id) { preset in
                    Button {
                        selectedPreset = preset.id
                        if preset.id != "custom" {
                            volumeMl = preset.volume
                            strengthPct = preset.abv
                            customLabel = ""
                        }
                    } label: {
                        HStack {
                            Text(preset.label)
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                            Spacer()
                            if selectedPreset == preset.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(Color.antidotteAccent)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            if selectedPreset == "custom" {
                Section("Custom +1") {
                    TextField("Label (e.g. My IPA)", text: $customLabel)

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Volume")
                            Spacer()
                            Text("\(Int(volumeMl)) ml")
                                .font(.subheadline.monospacedDigit())
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: $volumeMl, in: 10...1000, step: 5)
                            .tint(Color.antidotteAccent)
                    }
                    .padding(.vertical, 4)

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Strength")
                            Spacer()
                            Text(String(format: "%.1f%%", strengthPct))
                                .font(.subheadline.monospacedDigit())
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: $strengthPct, in: 0...70, step: 0.5)
                            .tint(Color.antidotteAccent)
                    }
                    .padding(.vertical, 4)
                }
            }

            Section {
                Button {
                    Task { await save() }
                } label: {
                    HStack {
                        Text(saveSuccess ? "Saved!" : "Save")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                        if isSaving { ProgressView() }
                    }
                }
                .disabled(isSaving)
                .foregroundStyle(saveSuccess ? .green : Color.antidotteAccent)
            }
        }
        .navigationTitle("+1 definition")
        .navigationBarTitleDisplayMode(.inline)
        .task { await load() }
    }

    private func load() async {
        let profile = try? await APIClient.shared.getProfile()
        let preset = profile?["default_serving_preset"]?.value as? String ?? "beer_pint"
        selectedPreset = preset
        if let matching = presets.first(where: { $0.id == preset }), preset != "custom" {
            volumeMl = matching.volume
            strengthPct = matching.abv
        } else {
            volumeMl = profile?["default_volume_ml"]?.value as? Double ?? 568
            strengthPct = profile?["default_strength_pct"]?.value as? Double ?? 4.5
            customLabel = profile?["default_serving_label"]?.value as? String ?? ""
        }
    }

    private func save() async {
        isSaving = true
        let label = selectedPreset == "custom" ? customLabel : presets.first(where: { $0.id == selectedPreset })?.label ?? ""
        try? await APIClient.shared.updateSettings([
            "defaultServingPreset": AnyEncodable(selectedPreset),
            "defaultServingLabel": AnyEncodable(label),
            "defaultVolumeMl": AnyEncodable(volumeMl),
            "defaultStrengthPct": AnyEncodable(strengthPct),
        ])
        isSaving = false
        saveSuccess = true
        try? await Task.sleep(for: .seconds(2))
        saveSuccess = false
    }
}
