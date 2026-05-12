import SwiftUI

struct ScoreCalibrationView: View {
    @State private var weightKg: Double = 70
    @State private var heightCm: Double = 175
    @State private var drinksPerWeek: Double = 5
    @State private var sessionsPerWeek: Double = 1
    @State private var sportsHoursPerWeek: Double = 2
    @State private var toleranceLevel: String = "medium"
    @State private var isSaving = false
    @State private var saveSuccess = false

    private let toleranceLevels = [("low", "Low"), ("medium", "Medium"), ("high", "High")]

    var body: some View {
        List {
            Section("Body") {
                LabeledSlider(label: "Weight", value: $weightKg, range: 40...160, format: "%.0f kg")
                LabeledSlider(label: "Height", value: $heightCm, range: 140...220, format: "%.0f cm")
            }

            Section("Drinking habits") {
                LabeledSlider(label: "Drinks / week", value: $drinksPerWeek, range: 0...50, format: "%.0f")
                LabeledSlider(label: "Sessions / week", value: $sessionsPerWeek, range: 0...14, format: "%.0f")
            }

            Section("Fitness") {
                LabeledSlider(label: "Sport hours / week", value: $sportsHoursPerWeek, range: 0...30, format: "%.0f h")
            }

            Section("Tolerance") {
                Picker("Tolerance", selection: $toleranceLevel) {
                    ForEach(toleranceLevels, id: \.0) { id, label in
                        Text(label).tag(id)
                    }
                }
                .pickerStyle(.segmented)
                .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
            }

            Section {
                Button {
                    Task { await save() }
                } label: {
                    HStack {
                        Text(saveSuccess ? "Saved!" : "Save calibration")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                        if isSaving { ProgressView() }
                    }
                }
                .disabled(isSaving)
                .foregroundStyle(saveSuccess ? .green : Color.antidotteAccent)
            }
        }
        .navigationTitle("Score calibration")
        .navigationBarTitleDisplayMode(.inline)
        .task { await load() }
    }

    private func load() async {
        let profile = try? await APIClient.shared.getProfile()
        weightKg = profile?["body_weight_kg"]?.value as? Double ?? 70
        heightCm = profile?["height_cm"]?.value as? Double ?? 175
        drinksPerWeek = profile?["usual_drinks_per_week"]?.value as? Double ?? 5
        sessionsPerWeek = profile?["usual_sessions_per_week"]?.value as? Double ?? 1
        sportsHoursPerWeek = profile?["sports_hours_per_week"]?.value as? Double ?? 2
        toleranceLevel = profile?["tolerance_level"]?.value as? String ?? "medium"
    }

    private func save() async {
        isSaving = true
        try? await APIClient.shared.request(
            .updateCalibration,
            body: [
                "bodyWeightKg": AnyEncodable(weightKg),
                "heightCm": AnyEncodable(heightCm),
                "usualDrinksPerWeek": AnyEncodable(drinksPerWeek),
                "usualSessionsPerWeek": AnyEncodable(sessionsPerWeek),
                "sportsHoursPerWeek": AnyEncodable(sportsHoursPerWeek),
                "toleranceLevel": AnyEncodable(toleranceLevel),
            ]
        )
        isSaving = false
        saveSuccess = true
        try? await Task.sleep(for: .seconds(2))
        saveSuccess = false
    }
}

private struct LabeledSlider: View {
    let label: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let format: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label).font(.subheadline)
                Spacer()
                Text(String(format: format, value))
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            Slider(value: $value, in: range)
                .tint(Color.antidotteAccent)
        }
        .padding(.vertical, 4)
    }
}
