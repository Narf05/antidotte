import SwiftUI

enum JoinStatus: String {
    case joinMe = "join_me"
    case doNotJoin = "do_not_join"

    var label: String {
        switch self {
        case .joinMe:    return "Join me"
        case .doNotJoin: return "Do not join me"
        }
    }

    var color: Color {
        switch self {
        case .joinMe:    return .green
        case .doNotJoin: return .red
        }
    }
}

struct JoinStatusBadge: View {
    let status: JoinStatus

    var body: some View {
        Text(status.label)
            .font(.caption.bold())
            .foregroundColor(status.color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(status.color, lineWidth: 1))
    }
}
