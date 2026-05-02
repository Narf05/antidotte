import Foundation
import SwiftData

@Model
final class NightOutSession {
    var id: String
    var userId: String
    var ownerUserId: String
    var title: String
    var status: String
    var theme: String?
    var mood: String?
    var startedAt: Date
    var endedAt: Date?
    var timezoneIdentifier: String
    var privacyScope: String
    var primaryCity: String?
    var primaryCountry: String?
    var defaultRefreshmentPreset: String?
    var defaultServingLabel: String?
    var defaultStrengthPercentage: Double?
    var defaultPriceAmount: Double?
    var defaultPriceCurrency: String?
    var totalRefreshmentUnits: Double
    var totalSpendAmount: Double?
    var spendCurrency: String?
    var peakPercentage: Double?
    var averagePercentage: Double?
    var venueCount: Int
    var refreshmentCount: Int
    var participantCount: Int
    var calendarEventIdentifier: String?
    var createdAt: Date
    var updatedAt: Date
    var isActive: Bool

    init(id: String, userId: String, title: String, startedAt: Date) {
        self.id = id
        self.userId = userId
        self.ownerUserId = userId
        self.title = title
        self.status = SessionStatus.active.rawValue
        self.startedAt = startedAt
        self.timezoneIdentifier = TimeZone.current.identifier
        self.privacyScope = VisibilityLevel.friends.rawValue
        self.totalRefreshmentUnits = 0
        self.venueCount = 0
        self.refreshmentCount = 0
        self.participantCount = 1
        self.createdAt = Date()
        self.updatedAt = Date()
        self.isActive = true
    }
}
