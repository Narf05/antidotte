import SwiftUI

struct PlusOneButton: View {
    let onTap: () -> Void

    var body: some View {
        PlusOneOverlay(onTap: onTap)
    }
}
