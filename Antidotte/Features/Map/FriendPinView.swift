import SwiftUI

struct FriendPinView: View {
    let presence: FriendPresence
    var onTap: (() -> Void)? = nil

    private var initials: String {
        let parts = presence.displayName.split(separator: " ")
        if parts.count >= 2 {
            return "\(parts[0].prefix(1))\(parts[1].prefix(1))".uppercased()
        }
        return String(presence.displayName.prefix(2)).uppercased()
    }

    private var tipCategory: TipsinessCategory {
        TipsinessCategory(from: presence.drunknessPercentage)
    }

    private var joinStatus: JoinStatus {
        JoinStatus(rawValue: presence.joinStatus) ?? .joinMe
    }

    var body: some View {
        Button(action: { onTap?() }) {
            ZStack(alignment: .topTrailing) {
                // Avatar circle
                ZStack {
                    Circle()
                        .fill(tipCategory.color.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Circle()
                        .stroke(tipCategory.color, lineWidth: 2)
                        .frame(width: 44, height: 44)
                    Text(initials)
                        .font(.caption.bold())
                        .foregroundStyle(tipCategory.color)
                }

                // Join status dot
                Circle()
                    .fill(joinStatus.color)
                    .frame(width: 12, height: 12)
                    .overlay(Circle().stroke(.white, lineWidth: 1.5))
                    .offset(x: 2, y: -2)
            }
        }
        .buttonStyle(.plain)
        .opacity(presence.presenceState == "hidden" ? 0 : 1)
    }
}
