import SwiftUI

struct ReadyView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 20) {
                Image(systemName: "party.popper.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(Color.antidotteAccent)

                Text("You're all set!")
                    .font(.largeTitle.bold())

                Text("Tap +1 whenever you have a drink. The map lights up when friends go out.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 40)
            }

            Spacer()

            Button {
                appState.completeOnboarding()
            } label: {
                Text("Open the map")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.antidotteAccent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(Color.antidotteBackground.ignoresSafeArea())
    }
}
