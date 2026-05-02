import Foundation
import SwiftData

@Model
final class ScoreSnapshot {
    var id: String
    var userId: String
    var sessionId: String?
    var createdAt: Date
    var scoreAt: Date
    var percentage: Double
    var confidence: Double
    var motionComponent: Double?
    var phoneUsageComponent: Double?
    var refreshmentLogComponent: Double?
    var contextComponent: Double?
    var activeFloor: Double
    var floorReason: String?
    var visibility: String
    var isSynced: Bool

    init(
        id: String = UUID().uuidString,
        userId: String,
        scoreAt: Date = Date(),
        percentage: Double,
        confidence: Double = 0
    ) {
        self.id = id
        self.userId = userId
        self.createdAt = Date()
        self.scoreAt = scoreAt
        self.percentage = percentage
        self.confidence = confidence
        self.activeFloor = 0
        self.visibility = VisibilityLevel.private.rawValue
        self.isSynced = false
    }
}
