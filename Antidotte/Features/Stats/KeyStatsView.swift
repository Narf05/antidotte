import SwiftUI

struct KeyStatsView: View {
    let scoreHistory: [(date: Date, percentage: Double)]
    let sessions: [NightOutSession]

    private var avgScore: Double {
        guard !scoreHistory.isEmpty else { return 0 }
        return scoreHistory.map(\.percentage).reduce(0, +) / Double(scoreHistory.count)
    }

    private var peakScore: Double {
        scoreHistory.map(\.percentage).max() ?? 0
    }

    private var totalDrinks: Int {
        sessions.map(\.refreshmentCount).reduce(0, +)
    }

    private var totalSpend: Double {
        sessions.compactMap(\.totalSpendAmount).reduce(0, +)
    }

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            StatCell(label: "Avg score", value: "\(Int(avgScore))%")
            StatCell(label: "Peak score", value: "\(Int(peakScore))%")
            StatCell(label: "Sessions", value: "\(sessions.count)")
            StatCell(label: "Total drinks", value: "\(totalDrinks)")
            if totalSpend > 0 {
                StatCell(label: "Total spend", value: String(format: "€%.0f", totalSpend))
            }
        }
    }
}

private struct StatCell: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3.bold().monospacedDigit())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 12))
    }
}
