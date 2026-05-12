import SwiftUI

struct DrunkScoreSummaryView: View {
    let score: ScoreSnapshot?

    var body: some View {
        VStack(spacing: 12) {
            if let score {
                TipsinessBadge(percentage: score.percentage, showPercentage: true)

                HStack(spacing: 16) {
                    Label("Confidence \(Int(score.confidence * 100))%", systemImage: "gauge.medium")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } else {
                Text("No score yet")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("Log drinks or run an Alcotest to see your score.")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 12))
    }
}
