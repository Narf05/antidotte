import SwiftUI

struct DrinkDefaultsView: View {
    @State private var primaryPreset: String = "beer_pint"
    @State private var secondaryPreset: String = ""
    @State private var averagePrice: String = ""
    @State private var currency: String = "EUR"
    @State private var isSaving = false

    private let presets = ["beer_pint", "beer_can", "wine", "shot", "cocktail", "none"]
    private let presetLabels: [String: String] = [
        "beer_pint": "Beer (pint)",
        "beer_can":  "Beer (can)",
        "wine":      "Wine",
        "shot":      "Shot",
        "cocktail":  "Cocktail",
        "none":      "None",
    ]
    private let currencies = ["EUR", "USD", "GBP", "SEK", "NOK", "DKK", "CHF"]

    var body: some View {
        List {
            Section("Primary drink") {
                Picker("Preset", selection: $primaryPreset) {
                    ForEach(presets.filter { $0 != "none" }, id: \.self) { p in
                        Text(presetLabels[p] ?? p).tag(p)
                    }
                }
            }

            Section("Secondary drink (optional)") {
                Picker("Preset", selection: $secondaryPreset) {
                    ForEach(presets, id: \.self) { p in
                        Text(presetLabels[p] ?? p).tag(p)
                    }
                }
            }

            Section("Average price") {
                HStack {
                    Picker("Currency", selection: $currency) {
                        ForEach(currencies, id: \.self) { c in Text(c).tag(c) }
                    }
                    .frame(width: 90)
                    .pickerStyle(.menu)
                    Divider()
                    TextField("e.g. 7.50", text: $averagePrice)
                        .keyboardType(.decimalPad)
                }
            }

            Section {
                Button {
                    Task { await save() }
                } label: {
                    HStack {
                        Text("Save defaults")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                        if isSaving { ProgressView() }
                    }
                }
                .disabled(isSaving)
                .foregroundStyle(Color.antidotteAccent)
            }
        }
        .navigationTitle("Drink defaults")
        .navigationBarTitleDisplayMode(.inline)
        .task { await load() }
    }

    private func load() async {
        let profile = try? await APIClient.shared.getProfile()
        primaryPreset = profile?["default_refreshment_preset"]?.value as? String ?? "beer_pint"
        secondaryPreset = profile?["secondary_refreshment_preset"]?.value as? String ?? "none"
        currency = profile?["default_price_currency"]?.value as? String ?? "EUR"
        if let price = profile?["default_price_amount"]?.value as? Double {
            averagePrice = String(format: "%.2f", price)
        }
    }

    private func save() async {
        isSaving = true
        var body: [String: AnyEncodable] = [
            "defaultRefreshmentPreset": AnyEncodable(primaryPreset),
            "defaultPriceCurrency": AnyEncodable(currency),
        ]
        if secondaryPreset != "none" {
            body["secondaryRefreshmentPreset"] = AnyEncodable(secondaryPreset)
        }
        if let price = Double(averagePrice) {
            body["defaultPriceAmount"] = AnyEncodable(price)
        }
        try? await APIClient.shared.updateSettings(body)
        isSaving = false
    }
}
