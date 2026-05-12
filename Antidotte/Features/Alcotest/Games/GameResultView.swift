import SwiftUI

struct GameResultView: View {
    let result: ActiveTestResult
    let onNext: () -> Void

    private var category: TipsinessCategory { TipsinessCategory(from: result.normalizedScore) }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: category.systemImageName)
                .font(.system(size: 56))
                .foregroundStyle(category.color)

            TipsinessBadge(percentage: result.normalizedScore, showPercentage: true)

            Text(gameName(result.gameType))
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()

            Button("Next", action: onNext)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.antidotteAccent)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
        }
        .background(Color.antidotteBackground.ignoresSafeArea())
    }

    private func gameName(_ type: String) -> String {
        switch type {
        case "tap_the_dot":  return "Tap the Dot"
        case "hold_still":   return "Hold Still"
        case "memory_tray":  return "Memory Tray"
        case "straight_line": return "Straight Line"
        case "vibe_check":   return "Vibe Check"
        default:             return type
        }
    }
}
