import SwiftUI

struct ThemeSheetButton: View {
    @State private var showSheet = false

    var body: some View {
        Button {
            showSheet = true
        } label: {
            Image(systemName: "moon.stars")
                .padding(14)
                .background(Color.antidotteAccent)
                .clipShape(Circle())
        }
        .sheet(isPresented: $showSheet) {
            ThemeBottomSheet()
        }
    }
}
