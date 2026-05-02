import SwiftUI

struct RootView: View {
    @StateObject private var appState = AppState()

    var body: some View {
        Group {
            if !appState.isAuthenticated || !appState.hasCompletedOnboarding {
                OnboardingCoordinator()
            } else {
                MainTabView()
            }
        }
        .environmentObject(appState)
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            MapView()
                .tabItem { Label("Map", systemImage: "map") }
            StatsView()
                .tabItem { Label("Stats", systemImage: "chart.line.uptrend.xyaxis") }
            AlcotestView()
                .tabItem { Label("Test", systemImage: "waveform.path.ecg") }
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person") }
        }
    }
}
