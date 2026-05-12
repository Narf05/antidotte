import SwiftUI

struct FriendProfilePopout: View {
    let presence: FriendPresence

    private var tipCategory: TipsinessCategory {
        TipsinessCategory(from: presence.drunknessPercentage)
    }

    private var joinStatus: JoinStatus {
        JoinStatus(rawValue: presence.joinStatus) ?? .joinMe
    }

    private var locationLabel: String {
        switch presence.visibility {
        case "exact":        return "Exact location"
        case "rough_area":   return "Approximate area (~150m)"
        case "hidden":       return "Location hidden"
        default:             return "Location off"
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Drag handle
            Capsule()
                .fill(Color.gray.opacity(0.35))
                .frame(width: 36, height: 4)
                .padding(.top, 10)
                .padding(.bottom, 16)

            VStack(spacing: 20) {
                // Identity row
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(tipCategory.color.opacity(0.12))
                            .frame(width: 56, height: 56)
                        Text(String(presence.displayName.prefix(2)).uppercased())
                            .font(.title3.bold())
                            .foregroundStyle(tipCategory.color)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(presence.displayName).font(.headline)
                        if let session = presence.sessionTitle {
                            Text(session).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                    JoinStatusBadge(status: joinStatus, compact: true)
                }

                // Score
                if presence.presenceState != "hidden" {
                    TipsinessBadge(
                        category: tipCategory,
                        percentage: presence.drunknessPercentage,
                        showPercentage: presence.drunknessPercentage != nil
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                // Location precision label
                HStack {
                    Image(systemName: presence.visibility == "hidden" ? "eye.slash" : "location.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(locationLabel)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    if let seen = presence.lastSeenAt as Date? {
                        Text(seen, style: .relative)
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(Color.antidotteSurface)
        .presentationDetents([.height(260)])
    }
}
