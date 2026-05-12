import SwiftUI

struct ConnectedDevicesView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var roomCode: String = ""
    @State private var isHost = true
    @State private var joinCode = ""
    @State private var connectedPlayers: [String] = []
    @State private var isConnecting = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Picker("Role", selection: $isHost) {
                    Text("Host").tag(true)
                    Text("Join").tag(false)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
                .padding(.top, 8)

                if isHost {
                    hostPanel
                } else {
                    joinPanel
                }

                Spacer()
            }
            .background(Color.antidotteBackground.ignoresSafeArea())
            .navigationTitle("Connected devices")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private var hostPanel: some View {
        VStack(spacing: 20) {
            if roomCode.isEmpty {
                Button {
                    roomCode = String(Int.random(in: 100000...999999))
                    connectedPlayers = ["You (host)"]
                } label: {
                    Label("Create room", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.antidotteAccent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 24)
            } else {
                VStack(spacing: 8) {
                    Text("Room code")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(roomCode)
                        .font(.system(size: 40, weight: .bold, design: .monospaced))
                        .foregroundStyle(Color.antidotteAccent)
                    Button {
                        UIPasteboard.general.string = roomCode
                    } label: {
                        Label("Copy code", systemImage: "doc.on.doc")
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 24)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Connected (\(connectedPlayers.count))")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)

                    ForEach(connectedPlayers, id: \.self) { player in
                        HStack(spacing: 10) {
                            Circle().fill(.green).frame(width: 8, height: 8)
                            Text(player).font(.subheadline)
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }

    private var joinPanel: some View {
        VStack(spacing: 16) {
            Text("Enter the 6-digit code from the host")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            TextField("Room code", text: $joinCode)
                .font(.system(size: 32, weight: .bold, design: .monospaced))
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .padding(16)
                .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal, 24)

            Button {
                isConnecting = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    isConnecting = false
                }
            } label: {
                HStack {
                    if isConnecting { ProgressView().tint(.white) }
                    Text(isConnecting ? "Connecting…" : "Join room")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(joinCode.count == 6 ? Color.antidotteAccent : Color.gray.opacity(0.3))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(joinCode.count != 6 || isConnecting)
            .padding(.horizontal, 24)
        }
    }
}
