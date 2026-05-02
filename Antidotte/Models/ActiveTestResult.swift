import Foundation
import SwiftData

@Model
final class ActiveTestResult {
    var id: String
    var userId: String
    var sessionId: String?
    var createdAt: Date
    var gameType: String
    var testType: String
    var rawScore: Double
    var rawResultJSON: String?
    var normalizedScore: Double
    var confidence: Double
    var completedAt: Date
    var roundType: String
    var usedInScoreSnapshotId: String?
    var isSynced: Bool

    init(id: String, userId: String, gameType: String, rawScore: Double, normalizedScore: Double, completedAt: Date) {
        self.id = id
        self.userId = userId
        self.createdAt = Date()
        self.gameType = gameType
        self.testType = gameType
        self.rawScore = rawScore
        self.normalizedScore = normalizedScore
        self.confidence = 0
        self.completedAt = completedAt
        self.roundType = "quick"
        self.isSynced = false
    }
}
