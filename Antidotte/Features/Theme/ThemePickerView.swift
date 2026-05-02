import SwiftUI

struct ThemePickerView: View {
    @Binding var selection: String

    let presets = ["Casual", "Dinner", "Club", "House party", "Festival", "Bar crawl", "Celebration", "Date", "Solo", "Custom"]

    @State private var customInput = ""
    @FocusState private var customFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(presets.filter { $0 != "Custom" }, id: \.self) { preset in
                    Button { selection = preset } label: {
                        Text(preset)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(selection == preset ? Color.antidotteAccent.opacity(0.15) : Color.antidotteSurface)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selection == preset ? Color.antidotteAccent : .clear, lineWidth: 1.5)
                            }
                    }
                    .buttonStyle(.plain)
                }
            }

            HStack {
                TextField("Custom theme…", text: $customInput)
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
                        customFocused = false
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
