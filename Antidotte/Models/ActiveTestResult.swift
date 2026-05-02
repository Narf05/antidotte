import Foundation
import SwiftData

@Model
final class ActiveTestResult {
    var id: String
    var userId: String
    var sessionId: String?
    var gameType: String
    var rawScore: Double
    var normalizedScore: Double
    var confidence: Double
    var completedAt: Date
    var roundType: String

    init(id: String, userId: String, gameType: String, rawScore: Double, normalizedScore: Double, completedAt: Date) {
        self.id = id
        self.userId = userId
        self.gameType = gameType
        self.rawScore = rawScore
        self.normalizedScore = normalizedScore
        self.confidence = 0
        self.completedAt = completedAt
        self.roundType = "quick"
    }
}
