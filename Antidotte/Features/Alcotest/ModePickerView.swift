import SwiftUI

struct ModePickerView: View {
    @ObservedObject var viewModel: AlcotestViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 16) {
                    Text("Alcotest")
                        .font(.largeTitle.bold())
                    Text("How impaired are you, really?")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom, 40)

                VStack(spacing: 14) {
                    ModeButton(
                        title: "Solo test",
                        subtitle: "Quick, full, or custom round",
                        icon: "person.fill"
                    ) {
                        viewModel.mode = .singlePlayer
                    }

                    ModeButton(
                        title: "Pass the phone",
                        subtitle: "Multiplayer — compare with friends",
                        icon: "person.2.fill"
                    ) {
                        viewModel.startQuickRound()
                        viewModel.mode = .multiplayer
                    }
                }
                .padding(.horizontal, 24)

                Spacer()
            }
            .background(Color.antidotteBackground.ignoresSafeArea())
            .sheet(isPresented: Binding(
                get: { viewModel.mode == .singlePlayer },
                set: { if !$0 { viewModel.mode = nil } }
            )) {
                RoundPickerView(viewModel: viewModel)
            }
            .fullScreenCover(isPresented: Binding(
                get: { viewModel.mode == .multiplayer },
                set: { if !$0 { viewModel.mode = nil } }
            )) {
                MultiplayerSetupView(viewModel: viewModel)
            }
        }
    }
}

private struct ModeButton: View {
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
