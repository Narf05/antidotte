import Foundation
import SwiftData

@MainActor
final class StorageContainer {
    static let shared = StorageContainer()

    let modelContainer: ModelContainer

    private init() {
        let schema = Schema([
            User.self,
            DrinkLog.self,
            NightOutSession.self,
            Venue.self,
            FriendPresence.self,
            ActiveTestResult.self,
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
    }
}
