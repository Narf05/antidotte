import Foundation
import SwiftData

@Model
final class Venue {
    var id: String
    var name: String
    var latitude: Double
    var longitude: Double
    var city: String?
    var country: String?
    var averageDrinkPrice: Double?
    var currency: String?

    init(id: String, name: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}
