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
        Task {
            struct HistoryEntry: Decodable {
                let createdAt: String
                let percentage: Double
            }
            struct SessionItem: Decodable {
                let id: String
                let title: String
                let startedAt: String
                let endedAt: String?
            }

            let from = rangeStart(for: selectedRange)
            let to = Date()

            let entries = try? await APIClient.shared.request(
                .scoreHistory,
                responseType: [HistoryEntry].self
            )
            if let entries {
                let df = ISO8601DateFormatter()
                scoreHistory = entries.compactMap { entry in
                    guard let date = df.date(from: entry.createdAt) else { return nil }
                    return (date: date, percentage: entry.percentage)
                }
            }
        }
    }

    private func rangeStart(for range: TimeRange) -> Date {
        let now = Date()
        switch range {
        case .oneHour:  return now.addingTimeInterval(-3600)
        case .sixHours: return now.addingTimeInterval(-6 * 3600)
        case .oneDay:   return now.addingTimeInterval(-24 * 3600)
        case .oneWeek:  return now.addingTimeInterval(-7 * 24 * 3600)
        case .oneMonth: return now.addingTimeInterval(-30 * 24 * 3600)
        case .oneYear:  return now.addingTimeInterval(-365 * 24 * 3600)
        case .allTime:  return Date(timeIntervalSince1970: 0)
        }
    }
}
