import SwiftUI
import Charts

struct SessionDetailView: View {
    let session: NightOutSession
    @State private var scoreHistory: [(date: Date, percentage: Double)] = []
    @State private var isLoading = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerSection
                if !scoreHistory.isEmpty {
                    chartSection
                }
                statsSection
            }
            .padding(.vertical, 16)
        }
        .background(Color.antidotteBackground.ignoresSafeArea())
        .navigationTitle(session.title)
        .navigationBarTitleDisplayMode(.inline)
        .task { await loadHistory() }
    }

    private var headerSection: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.startedAt, style: .date)
                    .font(.subheadline.weight(.medium))
                if let end = session.endedAt {
                    let duration = Int(end.timeIntervalSince(session.startedAt) / 3600)
                    Text("\(duration)h session")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                if let city = session.primaryCity {
                    Label(city, systemImage: "location.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            if let peak = session.peakPercentage {
                VStack(spacing: 2) {
                    TipsinessBadge(percentage: peak, showPercentage: true)
                    Text("Peak")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .padding(16)
        .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 20)
    }

    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Score timeline")
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 20)

            ScoreChartView(data: scoreHistory, range: .oneDay)
                .padding(.horizontal, 20)
        }
        .padding(.vertical, 12)
        .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 20)
    }

    private var statsSection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            StatTile(label: "Drinks", value: "\(session.refreshmentCount)", icon: "wineglass")
            StatTile(label: "Venues", value: "\(session.venueCount)", icon: "location")
            if let avg = session.averagePercentage {
                StatTile(label: "Avg score", value: "\(Int(avg))%", icon: "chart.bar")
            }
            if let spend = session.totalSpendAmount, spend > 0 {
                StatTile(label: "Spend", value: String(format: "€%.0f", spend), icon: "eurosign.circle")
            }
        }
        .padding(.horizontal, 20)
    }

    private func loadHistory() async {
        struct Entry: Decodable {
            let createdAt: String
            let percentage: Double
        }
        let entries = try? await APIClient.shared.request(
            .scoreHistory,
            responseType: [Entry].self
        )
        let df = ISO8601DateFormatter()
        if let entries {
            scoreHistory = entries.compactMap { e in
                guard let d = df.date(from: e.createdAt) else { return nil }
                return (date: d, percentage: e.percentage)
            }
        }
        isLoading = false
    }
}

private struct StatTile: View {
    let label: String
    let value: String
    let icon: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.callout)
                .foregroundStyle(Color.antidotteAccent)
            VStack(alignment: .leading, spacing: 2) {
                Text(value).font(.subheadline.bold())
                Text(label).font(.caption2).foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 12))
    }
}
