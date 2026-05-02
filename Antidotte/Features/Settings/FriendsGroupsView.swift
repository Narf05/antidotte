import SwiftUI

struct FriendsGroupsView: View {
    @State private var friends: [FriendRow] = []
    @State private var blocked: [FriendRow] = []
    @State private var inviteCode: String? = nil
    @State private var showInviteSheet = false
    @State private var searchText = ""
    @State private var isLoading = false

    var body: some View {
        List {
            Section {
                Button {
                    Task { await generateInviteCode() }
                } label: {
                    Label("Generate invite code", systemImage: "qrcode")
                        .foregroundStyle(Color.antidotteAccent)
                }
            }

            if let code = inviteCode {
                Section("Your invite code") {
                    HStack {
                        Text(code)
                            .font(.system(.body, design: .monospaced))
                            .foregroundStyle(.primary)
                        Spacer()
                        Button {
                            UIPasteboard.general.string = code
                        } label: {
                            Image(systemName: "doc.on.doc")
                                .foregroundStyle(Color.antidotteAccent)
                        }
                    }
                }
            }

            Section("Friends (\(friends.count))") {
                if friends.isEmpty && !isLoading {
                    Text("No friends yet. Share your invite code to connect.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(friends) { friend in
                        HStack(spacing: 12) {
                            Text(String(friend.displayName.prefix(2)).uppercased())
                                .font(.caption.bold())
                                .foregroundStyle(.white)
                                .frame(width: 36, height: 36)
                                .background(Color.antidotteAccent, in: Circle())

                            VStack(alignment: .leading, spacing: 2) {
                                Text(friend.displayName).font(.subheadline)
                                Text("@\(friend.username)").font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete { offsets in
                        Task { await removeFriends(at: offsets) }
                    }
                }
            }

            if !blocked.isEmpty {
                Section("Blocked") {
                    ForEach(blocked) { user in
                        HStack {
                            Text(user.displayName).font(.subheadline)
                            Spacer()
                            Button("Unblock") {
                                Task { await unblock(userId: user.id) }
                            }
                            .font(.caption)
                            .foregroundStyle(.orange)
                        }
                    }
                }
            }
        }
        .navigationTitle("Friends & groups")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { EditButton() }
        .task { await loadFriends() }
    }

    private func loadFriends() async {
        isLoading = true
        struct FriendResponse: Decodable {
            let friendId: String
            let displayName: String
            let username: String
        }
        let response = try? await APIClient.shared.request(
            .friends,
            responseType: [FriendResponse].self
        )
        friends = (response ?? []).map { FriendRow(id: $0.friendId, displayName: $0.displayName, username: $0.username) }
        isLoading = false
    }

    private func removeFriends(at offsets: IndexSet) async {
        for index in offsets {
            let friend = friends[index]
            try? await APIClient.shared.request(
                .removeFriend(friendId: friend.id),
                responseType: EmptyResponse.self
            )
        }
        friends.remove(atOffsets: offsets)
    }

    private func unblock(userId: String) async {
        blocked.removeAll { $0.id == userId }
    }

    private func generateInviteCode() async {
        struct CodeResponse: Decodable { let code: String }
        let response = try? await APIClient.shared.request(
            .generateInviteCode,
            responseType: CodeResponse.self
        )
        inviteCode = response?.code
    }
}

private struct FriendRow: Identifiable {
    let id: String
    let displayName: String
    let username: String
}

private struct EmptyResponse: Decodable {}
