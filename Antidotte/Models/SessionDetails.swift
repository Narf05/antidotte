import Foundation
import SwiftData

@Model
final class SessionVenue {
    var id: String
    var sessionId: String
    var venueId: String?
    var venueNameSnapshot: String?
    var arrivedAt: Date?
    var leftAt: Date?
    var source: String
    var isPrivatePlace: Bool

    init(id: String = UUID().uuidString, sessionId: String) {
        self.id = id
        self.sessionId = sessionId
        self.source = LocationSource.manual.rawValue
        self.isPrivatePlace = false
    }
}

@Model
final class SessionParticipant {
    var id: String
    var sessionId: String
    var userId: String
    var displayNameSnapshot: String?
    var role: String
    var joinedAt: Date
    var leftAt: Date?
    var visibilityStatus: String
    var consentStatus: String

    init(id: String = UUID().uuidString, sessionId: String, userId: String, joinedAt: Date = Date()) {
        self.id = id
        self.sessionId = sessionId
        self.userId = userId
        self.role = "joined"
        self.joinedAt = joinedAt
        self.visibilityStatus = "visible"
        self.consentStatus = "accepted"
    }
}

@Model
final class RefreshmentCompanion {
    var id: String
    var drinkLogId: String
    var companionUserId: String?
    var companionDisplayName: String?
    var source: String

    init(id: String = UUID().uuidString, drinkLogId: String) {
        self.id = id
        self.drinkLogId = drinkLogId
        self.source = "manual"
    }
}

@Model
final class PhotoAnalysis {
    var id: String
    var userId: String
    var drinkLogId: String?
    var createdAt: Date
    var photoStorageKey: String?
    var photoDeletedAt: Date?
    var detectedRefreshmentType: String?
    var detectedVolumeMl: Int?
    var detectedStrengthPercentage: Double?
    var detectedPriceAmount: Double?
    var detectedPriceCurrency: String?
    var confidence: Double
    var userConfirmed: Bool

    init(id: String = UUID().uuidString, userId: String) {
        self.id = id
        self.userId = userId
        self.createdAt = Date()
        self.confidence = 0
        self.userConfirmed = false
    }
}
