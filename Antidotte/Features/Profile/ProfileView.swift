import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject private var appState: AppState
    @State private var showSettings = false
    @State private var showStartSession = false
    @State private var sessionTitle = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Identity
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color.antidotteAccent.opacity(0.15))
                                .frame(width: 72, height: 72)
                            Text(String(viewModel.displayName.prefix(2)).uppercased())
                                .font(.title.bold())
                                .foregroundStyle(Color.antidotteAccent)
                        }
                        Text(viewModel.displayName).font(.title3.bold())
                        Text("@\(viewModel.username)").font(.subheadline).foregroundStyle(.secondary)
                    }
                    .padding(.top, 16)

                    // Score
                    if let score = viewModel.currentScore {
                        VStack(spacing: 8) {
                            TipsinessBadge(
                                percentage: score.percentage,
                                showPercentage: true
                            )
                            Text("Confidence \(Int(score.confidence * 100))%")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 20)
                    }

                    // Session controls
                    if let sessionId = appState.currentSessionId {
                        Button {
                            Task {
                                try? await viewModel.endSession(id: sessionId)
                                appState.clearSession()
                            }
                        } label: {
                            Label("End night out", systemImage: "moon.zzz.fill")
                                .font(.subheadline.weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.antidotteDanger.opacity(0.12))
                                .foregroundStyle(Color.antidotteDanger)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 20)
                    } else {
                        Button { showStartSession = true } label: {
                            Label("Start a night out", systemImage: "moon.stars.fill")
                                .font(.subheadline.weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.antidotteAccent.opacity(0.12))
                                .foregroundStyle(Color.antidotteAccent)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 40)
            }
            .background(Color.antidotteBackground.ignoresSafeArea())
            .navigationTitle("Me")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showSettings = true } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $showSettings) { SettingsView() }
            .alert("Start a night out", isPresented: $showStartSession) {
                TextField("Session name (optional)", text: $sessionTitle)
                Button("Start") {
                    Task {
                        let title = sessionTitle.isEmpty ? "Night out" : sessionTitle
                        if let id = try? await viewModel.startSession(title: title) {
                            appState.startSession(id: id)
                        }
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
        }
        .onAppear { viewModel.loadProfile() }
    }
}
