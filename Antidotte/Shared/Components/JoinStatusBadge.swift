import SwiftUI

enum JoinStatus: String, CaseIterable, Identifiable, Codable {
    case joinMe = "join_me"
    case askFirst = "ask_first"
    case doNotJoin = "do_not_join"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .joinMe: return "Join me"
        case .askFirst: return "Ask first"
        case .doNotJoin: return "Do not join"
        }
    }

    var systemImageName: String {
        switch self {
        case .joinMe: return "person.2.fill"
        case .askFirst: return "questionmark.bubble.fill"
        case .doNotJoin: return "lock.fill"
        }
    }

    var color: Color {
        switch self {
        case .joinMe: return .tipsFresh
        case .askFirst: return .tipsBuzzing
        case .doNotJoin: return .antidotteDanger
        }
    }
}

struct JoinStatusBadge: View {
    let status: JoinStatus
    var compact: Bool = false

    var body: some View {
        Label {
            if !compact {
                Text(status.label)
                    .font(.caption.weight(.semibold))
            }
        } icon: {
            Image(systemName: status.systemImageName)
                .font(.caption.weight(.bold))
        }
        .labelStyle(.titleAndIcon)
        .foregroundColor(status.color)
        .padding(.horizontal, compact ? 7 : 9)
        .padding(.vertical, 5)
        .background(status.color.opacity(0.12), in: Capsule())
        .overlay {
            Capsule().stroke(status.color.opacity(0.45), lineWidth: 1)
        }
        .accessibilityLabel(status.label)
    }
}
