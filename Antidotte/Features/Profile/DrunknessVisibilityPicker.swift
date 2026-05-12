import SwiftUI

struct DrunknessVisibilityPicker: View {
    @Binding var selection: String

    private let options = [
        ("category",   "Category only",  "Buzzing"),
        ("percentage", "Percentage only","42%"),
        ("both",       "Both",           "Buzzing · 42%"),
        ("hidden",     "Hidden",         "—"),
    ]

    var body: some View {
        VStack(spacing: 8) {
            ForEach(options, id: \.0) { id, label, example in
                Button { selection = id } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(label).font(.subheadline.weight(.medium))
                        }
                        Spacer()
                        Text(example)
                            .font(.caption.monospacedDigit())
                            .foregroundStyle(.secondary)
                        if selection == id {
                            Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.antidotteAccent)
                        }
                    }
                    .padding(12)
                    .background(selection == id ? Color.antidotteAccent.opacity(0.08) : Color.antidotteSurface)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
            }
        }
    }
}
