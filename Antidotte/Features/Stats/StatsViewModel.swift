import Foundation

@MainActor
final class StatsViewModel: ObservableObject {
    @Published var scoreHistory: [(date: Date, percentage: Double)] = []
    @Published var sessions: [NightOutSession] = []
    @Published var selectedRange: TimeRange = .oneWeek

    enum TimeRange: String, CaseIterable {
        case oneHour  = "1H"
        case sixHours = "6H"
        case oneDay   = "24H"
        case oneWeek  = "1W"
        case oneMonth = "1M"
        case oneYear  = "1Y"
        case allTime  = "ALL"
    }

    func loadData() {
        // TODO: fetch score snapshots and sessions from backend/local
    }
}
