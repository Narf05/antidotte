import SwiftUI

struct ScoreChartView: View {
    let data: [(date: Date, percentage: Double)]
    let range: StatsViewModel.TimeRange

    var body: some View {
        // TODO: stock-style line chart, color-coded bands, drink markers, scrub/zoom
        EmptyView()
    }
}
