import SwiftUI

struct GroupClusterView: View {
    let presences: [FriendPresence]
    @State private var expanded = false

    var body: some View {
        ZStack {
            if expanded {
                expandedSheet
            } else {
                clusterBubble
            }
        }
    }

    private var clusterBubble: some View {
        Button { expanded = true } label: {
            ZStack {
                Circle()
                    .fill(Color.antidotteAccent)
                    .frame(width: 48, height: 48)
                    .shadow(radius: 4)

                VStack(spacing: 0) {
                    HStack(spacing: -8) {
                        ForEach(presences.prefix(3), id: \.userId) { presence in
                            Text(String(presence.displayName.prefix(1)).uppercased())
                                .font(.caption2.bold())
                                .foregroundStyle(.white)
                                .frame(width: 20, height: 20)
                                .background(avatarColor(for: presence.userId), in: Circle())
                                .overlay(Circle().stroke(Color.antidotteAccent, lineWidth: 1))
                        }
                    }
                    Text("+\(presences.count)")
                        .font(.system(size: 9).bold())
                        .foregroundStyle(.white)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var expandedSheet: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("\(presences.count) here")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Button { expanded = false } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
            .padding(14)

            Divider()

            ScrollView {
                VStack(spacing: 0) {
                    ForEach(presences, id: \.userId) { presence in
                        HStack(spacing: 12) {
                            Text(String(presence.displayName.prefix(2)).uppercased())
                                .font(.caption.bold())
                                .foregroundStyle(.white)
                                .frame(width: 34, height: 34)
                                .background(avatarColor(for: presence.userId), in: Circle())

                            VStack(alignment: .leading, spacing: 2) {
                                Text(presence.displayName)
                                    .font(.subheadline)
                                if let pct = presence.drunknessPercentage {
                                    Text("\(Int(pct))%")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                } else if let cat = presence.drunknessCategory {
                                    Text(cat)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        Divider().padding(.leading, 60)
                    }
                }
            }
            .frame(maxHeight: 240)
        }
        .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 8)
        .frame(width: 240)
    }

    private func avatarColor(for userId: String) -> Color {
        let colors: [Color] = [.blue, .purple, .pink, .orange, .teal, .indigo]
        let index = abs(userId.hashValue) % colors.count
        return colors[index]
    }
}
