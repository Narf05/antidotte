import Foundation

@MainActor
final class ThemeViewModel: ObservableObject {
    @Published var sessionTitle: String = ""
    @Published var selectedTheme: String = ""
    @Published var drinkPreset: String = ""
    @Published var mood: String = ""
    @Published var averagePrice: Double? = nil
    @Published var currency: String = "EUR"

    func saveTheme(sessionId: String?) async throws {
        guard !sessionTitle.isEmpty || !selectedTheme.isEmpty else { return }
        if let sessionId {
            try await APIClient.shared.request(
                .updateSession(sessionId: sessionId),
                body: ["title": AnyEncodable(sessionTitle), "theme": AnyEncodable(selectedTheme)]
            )
        } else {
            let response = try await APIClient.shared.startSession(title: sessionTitle.isEmpty ? "Night out" : sessionTitle, theme: selectedTheme.isEmpty ? nil : selectedTheme)
            _ = response.sessionId
        }
    }
}
