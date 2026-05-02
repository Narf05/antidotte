import SwiftUI

struct CalibrationView: View {
    let next: () -> Void

    @State private var weightKg: String = ""
    @State private var heightCm: String = ""
    @State private var drinksPerSession: String = ""
    @State private var sessionsPerWeek: String = ""
    @State private var sports: String = ""
    @State private var toleranceRating: String = "medium"
    @State private var isLoading = false

    private var isValid: Bool { Double(weightKg) != nil }

    private let toleranceOptions = ["low", "medium", "high"]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                OnboardingHeader(
                    icon: "scalemass.fill",
                    title: "Score calibration",
                    subtitle: "This data is private — never shared with friends. It helps Antidotte estimate your drink score more accurately."
                )

                VStack(spacing: 14) {
                    OnboardingTextField("Body weight (kg) *", text: $weightKg)
                        .keyboardType(.decimalPad)

                    OnboardingTextField("Height (cm, optional)", text: $heightCm)
                        .keyboardType(.numberPad)

                    OnboardingTextField("Usual drinks per session", text: $drinksPerSession)
                        .keyboardType(.decimalPad)

                    OnboardingTextField("Sessions per week", text: $sessionsPerWeek)
                        .keyboardType(.decimalPad)

                    OnboardingTextField("Sports / physical activity (optional)", text: $sports)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Alcohol tolerance")
                            .font(.subheadline.weight(.medium))
                        Picker("Tolerance", selection: $toleranceRating) {
                            ForEach(toleranceOptions, id: \.self) { option in
                                Text(option.capitalized).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.horizontal, 4)
                }
                .padding(.horizontal, 24)

                OnboardingContinueButton(label: "Save & continue", isLoading: isLoading, isEnabled: isValid) {
                    saveAndContinue()
                }
            }
            .padding(.bottom, 40)
        }
        .background(Color.antidotteBackground.ignoresSafeArea())
    }

    private func saveAndContinue() {
        isLoading = true
        Task {
            try? await APIClient.shared.request(
                .calibration,
                body: [
                    "bodyWeightKg": AnyEncodable(Double(weightKg) ?? 70),
                    "heightCm": AnyEncodable(Double(heightCm) as Double?),
                    "usualDrinksPerSession": AnyEncodable(Double(drinksPerSession) as Double?),
                    "usualSessionsPerWeek": AnyEncodable(Double(sessionsPerWeek) as Double?),
                    "sports": AnyEncodable(sports.isEmpty ? nil : sports as String?),
                    "toleranceSelfRating": AnyEncodable(toleranceRating),
                ] as [String: AnyEncodable]
            )
            await MainActor.run {
                isLoading = false
                next()
            }
        }
    }
}
