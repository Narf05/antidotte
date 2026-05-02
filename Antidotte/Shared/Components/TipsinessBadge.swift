import SwiftUI

struct TipsinessBadge: View {
    let category: TipsinessCategory
    var showEmoji: Bool = true
    var showLabel: Bool = true

    var body: some View {
        HStack(spacing: 4) {
            if showEmoji { Text(category.emoji) }
            if showLabel { Text(category.rawValue).font(.caption.bold()) }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(badgeColor.opacity(0.2))
        .cornerRadius(8)
    }

    private var badgeColor: Color {
        switch category {
        case .fresh:    return .tipsFresh
        case .buzzing:  return .tipsBuzzing
        case .loose:    return .tipsLoose
        case .wavy:     return .tipsWavy
        case .goneMode: return .tipsGoneMode
        case .unknown:  return .gray
        }
    }
}
