import SwiftUI

struct ScoreboardView: View {
    let results: [ActiveTestResult]
    var onDone: (() -> Void)? = nil
    @Environment(\.dismiss) private var dismiss

    private var grouped: [(gameType: String, score: Double)] {
        Dictionary(grouping: results, by: \.gameType)
            .map { type, results in
                let avg = results.map(\.normalizedScore).reduce(0, +) / Double(results.count)
                return (gameType: type, score: avg)
            }
            .sorted { $0.score > $1.score }
    }

    private var overallScore: Double {
        guard !results.isEmpty else { return 0 }
        return results.map(\.normalizedScore).reduce(0, +) / Double(results.count)
    }

    var body: some View {
        ZStack {
            Color.antidotteBackground.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Text("Round complete!")
                    .font(.title2.bold())

                TipsinessBadge(percentage: overallScore, showPercentage: true)

                VStack(spacing: 0) {
                    ForEach(Array(grouped.enumerated()), id: \.element.gameType) { index, item in
                        HStack {
                            Text(medalEmoji(for: index))
                                .font(.title3)
                                .frame(width: 32)

                            Text(gameName(item.gameType))
                                .font(.subheadline)

                            Spacer()

                            Text("\(Int(item.score))%")
                                .font(.subheadline.bold().monospacedDigit())
                                .foregroundStyle(scoreColor(item.score))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)

                        if index < grouped.count - 1 {
                            Divider().padding(.leading, 52)
                        }
                    }
                }
                .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 20)

                Spacer()

                Button {
                    if let onDone = onDone { onDone() } else { dismiss() }
                } label: {
                    Text("Done")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.antidotteAccent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }

    private func medalEmoji(for rank: Int) -> String {
        switch rank {
        case 0: return "🥇"
        case 1: return "🥈"
        case 2: return "🥉"
        default: return "\(rank + 1)."
        }
    }

    private func gameName(_ type: String) -> String {
        switch type {
        case "tap_the_dot":   return "Tap the Dot"
        case "hold_still":    return "Hold Still"
        case "memory_tray":   return "Memory Tray"
        case "straight_line": return "Straight Line"
        case "vibe_check":    return "Vibe Check"
        default:              return type
        }
    }

    private func scoreColor(_ score: Double) -> Color {
        switch score {
        case ..<25:  return .green
        case ..<50:  return .yellow
        case ..<75:  return .orange
        default:     return .red
        }
    }
}
