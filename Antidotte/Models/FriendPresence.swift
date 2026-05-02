import Foundation
import SwiftData

@Model
final class FriendPresence {
    var userId: String
    var displayName: String
    var visibility: String
    var latitude: Double?
    var longitude: Double?
    var roughAreaLatitude: Double?
    var roughAreaLongitude: Double?
    var drunknessCategory: String?
    var drunknessPercentage: Double?
    var joinStatus: String
    var sessionId: String?
    var lastSeenAt: Date
    var presenceState: String

    init(userId: String, displayName: String, visibility: String, lastSeenAt: Date) {
        self.userId = userId
        self.displayName = displayName
        self.visibility = visibility
        self.lastSeenAt = lastSeenAt
        self.joinStatus = "join_me"
        self.presenceState = "live"
    }
}
