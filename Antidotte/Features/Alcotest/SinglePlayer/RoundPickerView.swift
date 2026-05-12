import SwiftUI

struct RoundPickerView: View {
    @ObservedObject var viewModel: AlcotestViewModel
    @State private var showRunner = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 14) {
                    RoundOptionButton(
                        title: "Quick",
                        detail: "3 games · ~2 min",
                        icon: "bolt.fill"
                    ) {
                        viewModel.startQuickRound()
                        showRunner = true
                    }
                    RoundOptionButton(
                        title: "Full",
                        detail: "5 games · ~5 min",
                        icon: "chart.bar.fill"
                    ) {
                        viewModel.startFullRound()
                        showRunner = true
                    }
                }
                .padding(.horizontal, 24)

                Spacer()
            }
            .background(Color.antidotteBackground.ignoresSafeArea())
            .navigationTitle("Choose round")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $showRunner) {
                RoundRunnerView(games: viewModel.currentRound, viewModel: viewModel)
            }
        }
    }
}

private struct RoundOptionButton: View {
    let title: String
    let detail: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(Color.antidotteAccent)
                    .frame(width: 36)
                VStack(alignment: .leading, spacing: 3) {
                    Text(title).font(.headline)
                    Text(detail).font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "play.fill").foregroundStyle(Color.antidotteAccent)
            }
            .padding(18)
            .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}
