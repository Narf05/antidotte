import SwiftUI

// MARK: - Root

struct RootView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        ZStack {
            if !appState.isAuthenticated || !appState.hasCompletedOnboarding {
                OnboardingCoordinator()
                    .transition(.opacity)
            } else {
                MainTabView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: appState.isAuthenticated)
        .animation(.easeInOut(duration: 0.25), value: appState.hasCompletedOnboarding)
    }
}

// MARK: - Main Tab View

struct MainTabView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        ZStack(alignment: .top) {
            TabView(selection: $appState.selectedTab) {
                MapView()
                    .tag(AppState.Tab.map)
                    .tabItem {
                        Label("Map", systemImage: "map.fill")
                    }
                    .toolbarBackground(.visible, for: .tabBar)

                StatsView()
                    .tag(AppState.Tab.stats)
                    .tabItem {
                        Label("Stats", systemImage: "chart.line.uptrend.xyaxis")
                    }

                AlcotestView()
                    .tag(AppState.Tab.test)
                    .tabItem {
                        Label("Test", systemImage: "waveform.path.ecg")
                    }

                ProfileView()
                    .tag(AppState.Tab.profile)
                    .tabItem {
                        Label("Me", systemImage: "person.fill")
                    }
            }
            .tint(.primary)

            if appState.panicPrivacyActive {
                PanicPrivacyBar()
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: appState.panicPrivacyActive)
    }
}

// MARK: - Panic Privacy Bar

private struct PanicPrivacyBar: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "eye.slash.fill")
                .font(.caption)
            Text("Privacy mode — location and score hidden")
                .font(.caption.bold())
                .lineLimit(1)
            Spacer()
            Button("Disable") {
                appState.deactivatePanicPrivacy()
            }
            .font(.caption.bold())
            .foregroundColor(.white.opacity(0.75))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.black)
        .foregroundColor(.white)
    }
}