import Foundation
import SwiftData

@Model
final class Venue {
    var id: String
    var name: String
    var type: String
    var latitude: Double
    var longitude: Double
    var address: String?
    var city: String?
    var country: String?
    var averageDrinkPrice: Double?
    var averageRefreshmentPrice: Double?
    var currency: String?
    var priceConfidence: Double
    var source: String
    var isPrivatePlace: Bool
    var createdAt: Date
    var updatedAt: Date

    init(id: String, name: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.type = "other"
        self.latitude = latitude
        self.longitude = longitude
        self.priceConfidence = 0
        self.source = "user_reported"
        self.isPrivatePlace = false
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
