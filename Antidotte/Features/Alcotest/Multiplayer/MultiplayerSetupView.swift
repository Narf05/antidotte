import SwiftUI

struct MultiplayerSetupView: View {
    @ObservedObject var viewModel: AlcotestViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var mode: MultiMode? = nil

    enum MultiMode { case passThePhone, connectedDevices }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 16) {
                    Text("Multiplayer")
                        .font(.largeTitle.bold())
                    Text("Play together, compare results.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom, 40)

                VStack(spacing: 14) {
                    ModeCard(
                        title: "Pass the phone",
                        subtitle: "One phone, everyone takes a turn",
                        icon: "hand.raised.fill"
                    ) { mode = .passThePhone }

                    ModeCard(
                        title: "Connected devices",
                        subtitle: "Each player uses their own phone",
                        icon: "iphone.and.iphone"
                    ) { mode = .connectedDevices }
                }
                .padding(.horizontal, 24)

                Spacer()
            }
            .background(Color.antidotteBackground.ignoresSafeArea())
            .navigationTitle("Multiplayer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
            .fullScreenCover(item: Binding(
                get: { mode == .passThePhone ? PassMode() : nil },
                set: { if $0 == nil { mode = nil } }
            )) { _ in
                PassThePhoneView(games: viewModel.currentRound.isEmpty ? [.tapTheDot, .holdStill, .vibeCheck] : viewModel.currentRound, viewModel: viewModel)
            }
            .sheet(item: Binding(
                get: { mode == .connectedDevices ? ConnMode() : nil },
                set: { if $0 == nil { mode = nil } }
            )) { _ in
                ConnectedDevicesView()
            }
        }
    }
}

private struct PassMode: Identifiable { let id = "pass" }
private struct ConnMode: Identifiable { let id = "conn" }

private struct ModeCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(Color.antidotteAccent)
                    .frame(width: 40)
                VStack(alignment: .leading, spacing: 3) {
                    Text(title).font(.headline)
                    Text(subtitle).font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(.tertiary)
            }
            .padding(18)
            .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}
