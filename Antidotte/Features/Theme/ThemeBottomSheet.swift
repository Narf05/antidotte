import SwiftUI

private let themePresets = ["🍺 Bar night", "🎉 Party", "🍷 Dinner", "🏠 House party", "🎤 Karaoke", "🎵 Concert", "🌊 Beach", "Custom"]

struct ThemeBottomSheet: View {
    @StateObject private var viewModel = ThemeViewModel()
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var isSaving = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Session title
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Session name")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                        TextField("e.g. Friday night out", text: $viewModel.sessionTitle)
                            .padding(14)
                            .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal, 20)

                    // Theme preset
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Vibe")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            ForEach(themePresets, id: \.self) { preset in
                                Button { viewModel.selectedTheme = preset } label: {
                                    Text(preset)
                                        .font(.subheadline)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(viewModel.selectedTheme == preset ? Color.antidotteAccent.opacity(0.15) : Color.antidotteSurface)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(viewModel.selectedTheme == preset ? Color.antidotteAccent : .clear, lineWidth: 1.5)
                                        }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 16)
            }
            .background(Color.antidotteBackground.ignoresSafeArea())
            .navigationTitle("Night out")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isSaving = true
                        Task {
                            try? await viewModel.saveTheme(sessionId: appState.currentSessionId)
                            await MainActor.run { dismiss() }
                        }
                    } label: {
                        if isSaving { ProgressView() } else { Text("Save").font(.subheadline.weight(.semibold)) }
                    }
                    .disabled(isSaving)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
