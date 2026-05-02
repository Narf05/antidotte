import Foundation
import SwiftData

@Model
final class DrinkLog {
    var id: String
    var userId: String
    var sessionId: String?
    var createdAt: Date
    var drankAt: Date
    var timezoneIdentifier: String
    var drinkUnitCount: Double
    var alcoholPercentage: Double?
    var volumeMl: Int?
    var drinkType: String
    var servingSizeLabel: String?
    var drinkBrand: String?
    var priceAmount: Double?
    var priceCurrency: String?
    var priceSource: String?
    var priceConfidence: Double?
    var venueId: String?
    var venueNameSnapshot: String?
    var roughAreaLatitude: Double?
    var roughAreaLongitude: Double?
    var locationAccuracyM: Double?
    var locationSource: String
    var source: String
    var visibility: String
    var note: String?
    var photoAnalysisId: String?
    var inferenceConfidence: Double
    var enteredWhileOffline: Bool
    var isDeleted: Bool
    var isSynced: Bool
    var updatedAt: Date

    init(id: String, userId: String, drankAt: Date, drinkType: String) {
        self.id = id
        self.userId = userId
        self.createdAt = Date()
        self.drankAt = drankAt
        self.timezoneIdentifier = TimeZone.current.identifier
        self.drinkType = drinkType
        self.drinkUnitCount = 1.0
        self.locationSource = LocationSource.none.rawValue
        self.source = RefreshmentLogSource.plusOne.rawValue
        self.visibility = VisibilityLevel.private.rawValue
        self.inferenceConfidence = 100
        self.enteredWhileOffline = false
        self.isDeleted = false
        self.isSynced = false
        self.updatedAt = Date()
    }
}
