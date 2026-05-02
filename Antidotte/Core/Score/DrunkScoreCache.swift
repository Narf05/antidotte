import Foundation
import Combine

@MainActor
final class DrunkScoreCache: ObservableObject {
    static let shared = DrunkScoreCache()

    @Published var currentPercentage: Double = 0
    @Published var tipsinessCategory: TipsinessCategory = .unknown
    @Published var confidence: Double = 0
    @Published var lastUpdated: Date? = nil

    private init() {}

    func update(percentage: Double, confidence: Double) {
        self.currentPercentage = percentage
        self.confidence = confidence
        self.tipsinessCategory = TipsinessCategory(from: percentage)
        self.lastUpdated = Date()
    }
}
