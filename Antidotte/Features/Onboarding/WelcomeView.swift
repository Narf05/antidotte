import SwiftUI

struct WelcomeView: View {
    let next: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 20) {
                Image(systemName: "bubbles.and.sparkles.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(Color.antidotteAccent)

                Text("Antidotte")
                    .font(.largeTitle.bold())

                Text("Track your nights out with friends.\nSee who's out, where, and how they're doing — privately and on your terms.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 32)
            }

            Spacer()

            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "lock.shield.fill").foregroundStyle(Color.antidotteAccent)
                    Text("Your data stays private — you control exactly what friends see.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 24)

                Button(action: next) {
                    Text("Get started")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.antidotteAccent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 40)
        }
        .background(Color.antidotteBackground.ignoresSafeArea())
    }
}
