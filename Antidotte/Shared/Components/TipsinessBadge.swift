import SwiftUI

struct TipsinessBadge: View {
    let category: TipsinessCategory
    var percentage: Double? = nil
    var showEmoji: Bool = true
    var showLabel: Bool = true
    var showPercentage: Bool = false
    var compact: Bool = false

    init(
        category: TipsinessCategory,
        percentage: Double? = nil,
        showEmoji: Bool = true,
        showLabel: Bool = true,
        showPercentage: Bool = false,
        compact: Bool = false
    ) {
        self.category = category
        self.percentage = percentage
        self.showEmoji = showEmoji
        self.showLabel = showLabel
        self.showPercentage = showPercentage
        self.compact = compact
    }

    init(
        percentage: Double?,
        showEmoji: Bool = true,
        showLabel: Bool = true,
        showPercentage: Bool = true,
        compact: Bool = false
    ) {
        self.category = TipsinessCategory(from: percentage)
        self.percentage = percentage
        self.showEmoji = showEmoji
        self.showLabel = showLabel
        self.showPercentage = showPercentage
        self.compact = compact
    }

    var body: some View {
        HStack(spacing: compact ? 4 : 6) {
            if showEmoji {
                Image(systemName: category.systemImageName)
                    .font(.caption.weight(.bold))
                    .accessibilityHidden(true)
            }

            if showLabel && !compact {
                Text(category.label)
                    .font(.caption.weight(.semibold))
            }

            if showPercentage, let percentage {
                Text("\(Int(percentage.rounded()))%")
                    .font(.caption.monospacedDigit().weight(.bold))
            }
        }
        .foregroundStyle(category.color)
        .padding(.horizontal, compact ? 7 : 9)
        .padding(.vertical, 5)
        .background(category.color.opacity(0.14), in: Capsule())
        .overlay {
            Capsule().stroke(category.color.opacity(0.35), lineWidth: 1)
        }
        .accessibilityLabel(accessibilityText)
    }

    private var accessibilityText: String {
        if let percentage {
            return "\(category.accessibilityLabel), \(Int(percentage.rounded())) percent"
        }
        return category.accessibilityLabel
    }
}
