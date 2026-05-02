import SwiftUI

struct ThemePickerView: View {
    @Binding var selection: String

    let presets = ["Casual", "Dinner", "Club", "House party", "Festival", "Bar crawl", "Celebration", "Date", "Solo", "Custom"]

    var body: some View {
        // TODO: grid or list of theme presets with custom text input
        EmptyView()
    }
}
