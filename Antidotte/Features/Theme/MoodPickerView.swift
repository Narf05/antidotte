import SwiftUI

struct MoodPickerView: View {
    @Binding var selection: String

    let presets = ["Chill", "Big night", "Birthday", "Celebration", "After work", "Dancing", "Meeting friends", "Solo mode", "Custom"]

    var body: some View {
        // TODO: mood/role chips or list, optional custom input
        EmptyView()
    }
}
