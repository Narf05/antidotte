import SwiftUI
import Charts

struct ScoreChartView: View {
    let data: [(date: Date, percentage: Double)]
    let range: StatsViewModel.TimeRange

    @State private var selectedEntry: (date: Date, percentage: Double)? = nil

    private let bands: [(min: Double, max: Double, color: Color)] = [
        (0,  25,  .green.opacity(0.15)),
        (25, 50,  .yellow.opacity(0.12)),
        (50, 75,  .orange.opacity(0.12)),
        (75, 100, .red.opacity(0.12)),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let sel = selectedEntry {
                HStack {
                    Text(sel.date, style: .time)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(Int(sel.percentage))%")
                        .font(.subheadline.bold().monospacedDigit())
                        .foregroundStyle(colorForScore(sel.percentage))
                }
                .padding(.horizontal, 4)
                .padding(.bottom, 6)
            }

            Chart {
                ForEach(bands, id: \.min) { band in
                    RectangleMark(
                        xStart: nil,
                        xEnd: nil,
                        yStart: .value("Min", band.min),
                        yEnd: .value("Max", band.max)
                    )
                    .foregroundStyle(band.color)
                }

                ForEach(data, id: \.date) { entry in
                    AreaMark(
                        x: .value("Time", entry.date),
                        yStart: .value("Base", 0),
                        yEnd: .value("Score", entry.percentage)
                    )
                    .foregroundStyle(Color.antidotteAccent.opacity(0.15))
                    .interpolationMethod(.catmullRom)

                    LineMark(
                        x: .value("Time", entry.date),
                        y: .value("Score", entry.percentage)
                    )
                    .foregroundStyle(Color.antidotteAccent)
                    .lineStyle(StrokeStyle(lineWidth: 2.5))
                    .interpolationMethod(.catmullRom)
                }

                if let sel = selectedEntry {
                    RuleMark(x: .value("Selected", sel.date))
                        .foregroundStyle(Color.antidotteAccent.opacity(0.4))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 3]))
                    PointMark(
                        x: .value("Time", sel.date),
                        y: .value("Score", sel.percentage)
                    )
                    .foregroundStyle(Color.antidotteAccent)
                    .symbolSize(48)
                }
            }
            .chartYScale(domain: 0...100)
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 4)) { _ in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(format: xAxisFormat(for: range))
                }
            }
            .chartYAxis {
                AxisMarks(values: [0, 25, 50, 75, 100]) { val in
                    AxisGridLine().foregroundStyle(Color.gray.opacity(0.15))
                    AxisValueLabel { Text("\(val.as(Int.self) ?? 0)%").font(.caption2) }
                }
            }
            .chartOverlay { proxy in
                GeometryReader { geo in
                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { val in
                                    let x = val.location.x - geo.frame(in: .local).minX
                                    if let date: Date = proxy.value(atX: x),
                                       let nearest = nearestEntry(to: date) {
                                        selectedEntry = nearest
                                    }
                                }
                                .onEnded { _ in selectedEntry = nil }
                        )
                }
            }
            .frame(height: 180)
        }
    }

    private func nearestEntry(to date: Date) -> (date: Date, percentage: Double)? {
        data.min(by: { abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date)) })
    }

    private func colorForScore(_ score: Double) -> Color {
        switch score {
        case ..<25:  return .green
        case ..<50:  return .yellow
        case ..<75:  return .orange
        default:     return .red
        }
    }

    private func xAxisFormat(for range: StatsViewModel.TimeRange) -> Date.FormatStyle {
        switch range {
        case .oneHour, .sixHours: return .dateTime.hour().minute()
        case .oneDay:             return .dateTime.hour()
        case .oneWeek:            return .dateTime.weekday(.abbreviated)
        case .oneMonth:           return .dateTime.day()
        case .oneYear, .allTime:  return .dateTime.month(.abbreviated)
        }
    }
}
