import Foundation
import SwiftData

@Model
final class FriendPresence {
    var userId: String
    var displayName: String
    var profileImageURL: String?
    var visibility: String
    var latitude: Double?
    var longitude: Double?
    var accuracyM: Double?
    var roughAreaLatitude: Double?
    var roughAreaLongitude: Double?
    var venueId: String?
    var venueNameSnapshot: String?
    var drunknessCategory: String?
    var drunknessPercentage: Double?
    var scorePercentage: Double?
    var scoreColorHex: String?
    var joinStatus: String
    var sessionId: String?
    var sessionTitle: String?
    var sessionTheme: String?
    var mood: String?
    var lastSeenAt: Date
    var staleSince: Date?
    var hideAfter: Date?
    var presenceState: String
    var batteryMode: String?
    var updatedAt: Date

    init(userId: String, displayName: String, visibility: String, lastSeenAt: Date) {
        self.userId = userId
        self.displayName = displayName
        self.visibility = visibility
        self.lastSeenAt = lastSeenAt
        self.joinStatus = "join_me"
        self.presenceState = PresenceState.live.rawValue
        self.updatedAt = Date()
    }
}
