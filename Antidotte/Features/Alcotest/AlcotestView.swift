import SwiftUI

struct AlcotestView: View {
    @StateObject private var viewModel = AlcotestViewModel()

    var body: some View {
        ModePickerView(viewModel: viewModel)
    }
}
