import SwiftUI

struct FriendRankingView: View {
    let friendPresences: [FriendPresence]

    private var ranked: [FriendPresence] {
        friendPresences
            .filter { $0.drunknessPercentage != nil }
            .sorted { ($0.drunknessPercentage ?? 0) > ($1.drunknessPercentage ?? 0) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Friend ranking")
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 20)

            if ranked.isEmpty {
                EmptyStateView(
                    title: "No data yet",
                    message: "Friends' scores appear here when they're out.",
                    systemImageName: "person.2"
                )
                .padding(.horizontal, 20)
            } else {
                ForEach(Array(ranked.enumerated()), id: \.element.userId) { index, presence in
                    RankRow(rank: index + 1, presence: presence)
                        .padding(.horizontal, 20)
                }
            }
        }
    }
}

private struct RankRow: View {
    let rank: Int
    let presence: FriendPresence

    var body: some View {
        HStack(spacing: 14) {
            Text("\(rank)")
                .font(.subheadline.bold().monospacedDigit())
                .foregroundStyle(rankColor)
                .frame(width: 24, alignment: .center)

            Text(initials)
                .font(.caption.bold())
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(Color.antidotteAccent, in: Circle())

            Text(presence.displayName)
                .font(.subheadline)
                .lineLimit(1)

            Spacer()

            if let pct = presence.drunknessPercentage {
                TipsinessBadge(percentage: pct, showLabel: false, showPercentage: true, compact: true)
            } else if presence.drunknessCategory != nil {
                Text(presence.drunknessCategory ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Text("Hidden")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(12)
        .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 12))
    }

    private var initials: String {
        String(presence.displayName.prefix(2)).uppercased()
    }

    private var rankColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .brown
        default: return .secondary
        }
    }
}
