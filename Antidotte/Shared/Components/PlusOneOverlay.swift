import SwiftUI

struct PlusOneOverlay: View {
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text("+1")
                .font(.title2.bold())
                .frame(width: 56, height: 56)
                .background(Color.antidotteAccent)
                .clipShape(Circle())
                .shadow(radius: 4)
        }
    }
}
