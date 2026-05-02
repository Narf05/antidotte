import SwiftUI

struct PlusOneOverlay: View {
    let onTap: () -> Void
    var showsCameraHint: Bool = false
    var isEnabled: Bool = true

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .topTrailing) {
                Text("+1")
                    .font(.title2.weight(.black))
                    .monospacedDigit()
                    .frame(width: 62, height: 62)
                    .foregroundStyle(.white)
                    .background(isEnabled ? Color.antidotteAccent : Color.gray, in: Circle())
                    .shadow(color: .black.opacity(0.20), radius: 8, x: 0, y: 4)

                if showsCameraHint {
                    Image(systemName: "camera.fill")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 22, height: 22)
                        .background(Color.antidottePrimary, in: Circle())
                        .offset(x: 3, y: -3)
                        .accessibilityHidden(true)
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .accessibilityLabel("Add one refreshment")
        .accessibilityHint(showsCameraHint ? "Photo assistance is available" : "Logs one refreshment")
    }
}
