import SwiftUI

private struct DrinkPreset: Identifiable {
    let id: String
    let label: String
    let icon: String
    let volumeMl: Int
    let abvPercent: Double
}

private let presets: [DrinkPreset] = [
    DrinkPreset(id: "beer_pint",     label: "Pint (beer)",        icon: "🍺", volumeMl: 568, abvPercent: 4.5),
    DrinkPreset(id: "beer_can",      label: "Can / bottle (beer)",icon: "🍻", volumeMl: 330, abvPercent: 5.0),
    DrinkPreset(id: "wine_glass",    label: "Glass of wine",      icon: "🍷", volumeMl: 175, abvPercent: 12.5),
    DrinkPreset(id: "shot",          label: "Shot / spirit",      icon: "🥃", volumeMl: 35,  abvPercent: 40.0),
    DrinkPreset(id: "cocktail",      label: "Cocktail",           icon: "🍹", volumeMl: 200, abvPercent: 12.0),
    DrinkPreset(id: "custom",        label: "Custom",             icon: "✏️", volumeMl: 0,   abvPercent: 0),
]

struct DrinkUnitView: View {
    let next: () -> Void

    @State private var selectedPreset = "beer_pint"
    @State private var customLabel = ""
    @State private var customVolume = ""
    @State private var customABV = ""

    private var isCustom: Bool { selectedPreset == "custom" }
    private var isValid: Bool {
        if isCustom { return !customLabel.isEmpty && Double(customVolume) != nil }
        return true
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                OnboardingHeader(
                    icon: "plus.circle.fill",
                    title: "Your +1 drink",
                    subtitle: "What does tapping +1 count as? You can change this later."
                )

                VStack(spacing: 10) {
                    ForEach(presets) { preset in
                        Button {
                            selectedPreset = preset.id
                        } label: {
                            HStack {
                                Text(preset.icon).font(.title2)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(preset.label).font(.subheadline.weight(.medium))
                                    if preset.volumeMl > 0 {
                                        Text("\(preset.volumeMl)ml · \(preset.abvPercent, specifier: "%.1f")% ABV")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                Spacer()
                                if selectedPreset == preset.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color.antidotteAccent)
                                }
                            }
                            .padding(14)
                            .background(selectedPreset == preset.id ? Color.antidotteAccent.opacity(0.1) : Color.antidotteSurface)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedPreset == preset.id ? Color.antidotteAccent : .clear, lineWidth: 1.5)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)

                if isCustom {
                    VStack(spacing: 12) {
                        OnboardingTextField("Label (e.g. \"My usual\")", text: $customLabel)
                        OnboardingTextField("Volume (ml)", text: $customVolume).keyboardType(.numberPad)
                        OnboardingTextField("Strength (% ABV)", text: $customABV).keyboardType(.decimalPad)
                    }
                    .padding(.horizontal, 24)
                }

                OnboardingContinueButton(label: "Save & continue", isEnabled: isValid) {
                    next()
                }
            }
            .padding(.bottom, 40)
        }
        .background(Color.antidotteBackground.ignoresSafeArea())
    }
}
