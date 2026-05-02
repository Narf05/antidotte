import SwiftUI

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // TODO: MapLibre OSM map layer

            // Friend pins
            ForEach(viewModel.friendPresences, id: \.userId) { presence in
                FriendPinView(presence: presence)
            }

            // +1 button — bottom left
            PlusOneOverlay { viewModel.logDrink() }
                .padding(24)

            // Location precision — top right
            VStack {
                HStack {
                    Spacer()
                    LocationPrecisionButton(precision: $viewModel.locationPrecision)
                        .padding()
                }
                Spacer()
            }

            // Theme sheet button — bottom right
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ThemeSheetButton()
                        .padding(24)
                }
            }
        }
        .sheet(isPresented: $viewModel.showFriendProfile) {
            if let friend = viewModel.selectedFriend {
                FriendProfilePopout(presence: friend)
            }
        }
    }
}
