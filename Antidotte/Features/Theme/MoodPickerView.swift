import SwiftUI

struct MoodPickerView: View {
    @Binding var selection: String

    let presets = ["Chill", "Big night", "Birthday", "Celebration", "After work", "Dancing", "Meeting friends", "Solo mode", "Custom"]

    @State private var customInput = ""
    @FocusState private var customFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            FlowLayout(spacing: 8) {
                ForEach(presets.filter { $0 != "Custom" }, id: \.self) { mood in
                    Button { selection = mood } label: {
                        Text(mood)
                            .font(.subheadline)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(selection == mood ? Color.antidotteAccent : Color.antidotteSurface)
                            .foregroundStyle(selection == mood ? .white : .primary)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }

            HStack {
                TextField("Custom mood…", text: $customInput)
                    .focused($customFocused)
                    .padding(10)
                    .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(!customInput.isEmpty ? Color.antidotteAccent : .clear, lineWidth: 1.5)
                    }
                    .onChange(of: customInput) { _, val in
                        if !val.isEmpty { selection = val }
                    }

                if !customInput.isEmpty {
                    Button {
                        customInput = ""
                        selection = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

private struct FlowLayout: Layout {
    let spacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        var height: CGFloat = 0
        var x: CGFloat = 0
        var rowHeight: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > width, x > 0 {
                height += rowHeight + spacing
                x = 0
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        height += rowHeight
        return CGSize(width: width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX {
                y += rowHeight + spacing
                x = bounds.minX
                rowHeight = 0
            }
            view.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
