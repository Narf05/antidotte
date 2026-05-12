import SwiftUI

private struct VisibilityOption: Identifiable {
    let id: String
    let label: String
    let description: String
    let example: String
}

private let options: [VisibilityOption] = [
    VisibilityOption(id: "category",    label: "Category only",  description: "Friends see a label like \"Buzzing\" or \"Loose\".", example: "Buzzing"),
    VisibilityOption(id: "percentage",  label: "Percentage only",description: "Friends see a number (e.g. 42%) without a label.", example: "42%"),
    VisibilityOption(id: "both",        label: "Category + %",   description: "Friends see both the label and the number.", example: "Buzzing · 42%"),
    VisibilityOption(id: "hidden",      label: "Hidden",         description: "Friends cannot see your score at all.", example: "—"),
]

struct DrunknessVisibilityView: View {
    let next: () -> Void

    @State private var selected = "category"
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 0) {
            OnboardingHeader(
                icon: "gauge.medium",
                title: "Score visibility",
                subtitle: "What do friends see when they check your score?"
            )

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(options) { option in
                        Button { selected = option.id } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(option.label).font(.subheadline.weight(.medium))
                                    Text(option.description).font(.caption).foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(option.example)
                                    .font(.caption.monospacedDigit())
                                    .foregroundStyle(Color.antidotteAccent)
                                    .padding(.trailing, 4)
                                if selected == option.id {
                                    Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.antidotteAccent)
                                }
                            }
                            .padding(14)
                            .background(selected == option.id ? Color.antidotteAccent.opacity(0.08) : Color.antidotteSurface)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selected == option.id ? Color.antidotteAccent : .clear, lineWidth: 1.5)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
            }

            OnboardingContinueButton(label: "Save & continue", isLoading: isLoading) {
                isLoading = true
                Task {
                    try? await APIClient.shared.updateSettings(["drunknessVisibility": AnyEncodable(selected)])
                    await MainActor.run { isLoading = false; next() }
                }
            }
        }
        .background(Color.antidotteBackground.ignoresSafeArea())
    }
}
