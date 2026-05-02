import Foundation
import SwiftData

@Model
final class NightOutSession {
    var id: String
    var userId: String
    var title: String
    var theme: String?
    var startedAt: Date
    var endedAt: Date?
    var privacyScope: String
    var primaryCity: String?
    var primaryCountry: String?
    var isActive: Bool

    init(id: String, userId: String, title: String, startedAt: Date) {
        self.id = id
        self.userId = userId
        self.title = title
        self.startedAt = startedAt
        self.privacyScope = "friends"
        self.isActive = true
    }
}
