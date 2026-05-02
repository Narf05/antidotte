import SwiftUI

struct GuestManagerView: View {
    @Binding var guests: [Guest]
    @State private var newName = ""
    @FocusState private var inputFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Players")
                .font(.headline)
                .padding(.horizontal, 20)

            if guests.isEmpty {
                Text("Add at least one player to continue.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 20)
            }

            ForEach($guests) { $guest in
                HStack(spacing: 12) {
                    Text(String(guest.name.prefix(2)).uppercased())
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .frame(width: 36, height: 36)
                        .background(avatarColor(for: guest.id), in: Circle())

                    Text(guest.name)
                        .font(.subheadline)

                    Spacer()

                    Button {
                        guests.removeAll { $0.id == guest.id }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 20)
            }

            HStack(spacing: 10) {
                TextField("Add player name…", text: $newName)
                    .focused($inputFocused)
                    .padding(12)
                    .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 10))
                    .submitLabel(.done)
                    .onSubmit { addGuest() }

                Button(action: addGuest) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color.antidotteAccent)
                }
                .disabled(newName.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal, 20)
        }
    }

    private func addGuest() {
        let name = newName.trimmingCharacters(in: .whitespaces)
        guard !name.isEmpty else { return }
        guests.append(Guest(id: UUID().uuidString, name: name))
        newName = ""
    }

    private func avatarColor(for id: String) -> Color {
        let colors: [Color] = [.blue, .purple, .pink, .orange, .teal, .indigo, .green, .red]
        return colors[abs(id.hashValue) % colors.count]
    }
}

struct Guest: Identifiable {
    let id: String
    var name: String
}
