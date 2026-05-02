import Foundation
import SwiftData

@MainActor
final class StorageContainer {
    static let shared = StorageContainer()

    let modelContainer: ModelContainer

    private init() {
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
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
    }
}
