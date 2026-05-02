import SwiftUI

struct FiltersView: View {
    @Binding var minScore: Double
    @Binding var maxScore: Double
    @Binding var selectedDrinkType: String?
    @Environment(\.dismiss) private var dismiss

    private let drinkTypes = ["Beer", "Wine", "Spirits", "Cocktail", "Other"]

    var body: some View {
        NavigationStack {
            List {
                Section("Score range") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Min: \(Int(minScore))% — Max: \(Int(maxScore))%")
                            .font(.subheadline.monospacedDigit())
                            .foregroundStyle(.secondary)
                        HStack {
                            Text("0%").font(.caption).foregroundStyle(.tertiary)
                            Slider(value: $minScore, in: 0...maxScore)
                            Text("\(Int(maxScore))%").font(.caption).foregroundStyle(.tertiary)
                        }
                        HStack {
                            Text("\(Int(minScore))%").font(.caption).foregroundStyle(.tertiary)
                            Slider(value: $maxScore, in: minScore...100)
                            Text("100%").font(.caption).foregroundStyle(.tertiary)
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section("Drink type") {
                    ForEach(drinkTypes, id: \.self) { type in
                        Button {
                            selectedDrinkType = selectedDrinkType == type ? nil : type
                        } label: {
                            HStack {
                                Text(type)
                                Spacer()
                                if selectedDrinkType == type {
                                    Image(systemName: "checkmark").foregroundStyle(Color.antidotteAccent)
                                }
                            }
                        }
                        .foregroundStyle(.primary)
                    }
                }

                Section {
                    Button(role: .destructive) {
                        minScore = 0
                        maxScore = 100
                        selectedDrinkType = nil
                    } label: {
                        Label("Clear filters", systemImage: "xmark.circle")
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }
}
