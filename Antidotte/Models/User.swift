import Foundation
import SwiftData

@Model
final class User {
    var id: String
    var username: String
    var displayName: String
    var profileImageURL: String?
    var bodyWeightKg: Double
    var drinkUnitDefinition: String
    var styleMode: String
    var drunknessVisibility: String

    init(id: String, username: String, displayName: String, bodyWeightKg: Double) {
        self.id = id
        self.username = username
        self.displayName = displayName
        self.bodyWeightKg = bodyWeightKg
        self.drinkUnitDefinition = "beer_33cl"
        self.styleMode = "chaos"
        self.drunknessVisibility = "category"
    }
}
