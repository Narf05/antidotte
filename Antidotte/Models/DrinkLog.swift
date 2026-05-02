import Foundation
import SwiftData

@Model
final class DrinkLog {
    var id: String
    var userId: String
    var sessionId: String?
    var drankAt: Date
    var drinkUnitCount: Double
    var alcoholPercentage: Double?
    var volumeMl: Int?
    var drinkType: String
    var priceAmount: Double?
    var priceCurrency: String?
    var venueId: String?
    var roughAreaLatitude: Double?
    var roughAreaLongitude: Double?
    var source: String
    var isDeleted: Bool
    var isSynced: Bool

    init(id: String, userId: String, drankAt: Date, drinkType: String) {
        self.id = id
        self.userId = userId
        self.drankAt = drankAt
        self.drinkType = drinkType
        self.drinkUnitCount = 1.0
        self.source = "plus_one"
        self.isDeleted = false
        self.isSynced = false
    }
}
