import SwiftUI
import SwiftData

@main
struct AntidotteApp: App {
    @StateObject private var appState = AppState()
    @Environment(\.scenePhase) private var scenePhase

    let modelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            DrinkLog.self,
            NightOutSession.self,
            Venue.self,
            FriendPresence.self,
            ActiveTestResult.self,
            ScoreSnapshot.self,
            SessionVenue.self,
            SessionParticipant.self,
            RefreshmentCompanion.self,
            PhotoAnalysis.self,
            LocationSample.self,
            LocationVisibilityRule.self,
            LiveLocationPresence.self,
            FriendRequest.self,
            Friendship.self,
            FriendInviteCode.self,
            FriendGroup.self,
            FriendGroupMember.self,
            UserBlock.self,
            SessionInvite.self,
            SocialNotification.self,
            FriendNotificationSetting.self,
            PrivacyConsent.self,
            PrivacyAuditEvent.self,
        ])
        do {
            return try ModelContainer(for: schema, configurations: [ModelConfiguration(schema: schema)])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .modelContainer(modelContainer)
        }
        .onChange(of: scenePhase) { _, phase in
            switch phase {
            case .background:
                appState.handleBackground()
            case .active:
                appState.handleForeground()
            default:
                break
            }
        }
    }
}
