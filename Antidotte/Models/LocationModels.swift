import Foundation
import SwiftData

@Model
final class LocationSample {
    var id: String
    var userId: String
    var sessionId: String?
    var createdAt: Date
    var sampledAt: Date
    var latitude: Double
    var longitude: Double
    var accuracyM: Double
    var speedMps: Double?
    var headingDeg: Double?
    var source: String
    var retentionClass: String
    var isSynced: Bool

    init(
        id: String = UUID().uuidString,
        userId: String,
        latitude: Double,
        longitude: Double,
        accuracyM: Double,
        sampledAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.createdAt = Date()
        self.sampledAt = sampledAt
        self.latitude = latitude
        self.longitude = longitude
        self.accuracyM = accuracyM
        self.source = LocationSource.gps.rawValue
        self.retentionClass = "realtime"
        self.isSynced = false
    }
}

@Model
final class LocationVisibilityRule {
    var id: String
    var ownerUserId: String
    var viewerUserId: String?
    var viewerGroupId: String?
    var visibility: String
    var activeOnlyDuringSession: Bool
    var expiresAt: Date?
    var createdAt: Date
    var updatedAt: Date

    init(id: String = UUID().uuidString, ownerUserId: String, visibility: VisibilityLevel = .exact) {
        self.id = id
        self.ownerUserId = ownerUserId
        self.visibility = visibility.rawValue
        self.activeOnlyDuringSession = false
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

@Model
final class LiveLocationPresence {
    var userId: String
    var sessionId: String?
    var lastSeenAt: Date
    var latitude: Double?
    var longitude: Double?
    var roughAreaLatitude: Double?
    var roughAreaLongitude: Double?
    var venueId: String?
    var venueNameSnapshot: String?
    var presenceState: String
    var staleSince: Date?
    var hideAfter: Date?
    var batteryMode: String?

    init(userId: String, lastSeenAt: Date = Date()) {
        self.userId = userId
        self.lastSeenAt = lastSeenAt
        self.presenceState = PresenceState.live.rawValue
    }
}
