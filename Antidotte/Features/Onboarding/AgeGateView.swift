import SwiftUI

struct AgeGateView: View {
    let next: () -> Void

    @State private var birthDate = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
    @State private var showError = false

    private var isOldEnough: Bool {
        let age = Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
        return age >= 16
    }

    var body: some View {
        VStack(spacing: 0) {
            OnboardingHeader(
                icon: "birthday.cake.fill",
                title: "Age confirmation",
                subtitle: "Antidotte is for adults and young adults 16+. Please confirm your date of birth."
            )

            Spacer()

            DatePicker(
                "Date of birth",
                selection: $birthDate,
                in: ...Date(),
                displayedComponents: .date
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .padding(.horizontal, 24)

            if showError {
                Text("You must be 16 or older to use Antidotte.")
                    .font(.caption)
                    .foregroundStyle(Color.antidotteDanger)
                    .padding(.top, 8)
            }

            Spacer()

            OnboardingContinueButton(label: "Continue") {
                if isOldEnough {
                    next()
                } else {
                    showError = true
                }
            }
        }
        .background(Color.antidotteBackground.ignoresSafeArea())
    }
}
