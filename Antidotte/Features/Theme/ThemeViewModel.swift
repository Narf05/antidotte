import Foundation

@MainActor
final class ThemeViewModel: ObservableObject {
    @Published var sessionTitle: String = ""
    @Published var selectedTheme: String = ""
    @Published var drinkPreset: String = ""
    @Published var mood: String = ""
    @Published var averagePrice: Double? = nil
    @Published var currency: String = "EUR"

    func saveTheme() {
        // TODO: update or create NightOutSession with theme data
    }
}
