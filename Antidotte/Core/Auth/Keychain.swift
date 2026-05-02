import Foundation
import Security

final class Keychain {
    static let shared = Keychain()
    private init() {}

    func save(key: String, value: String) {
        // TODO: implement SecItemAdd / SecItemUpdate
    }

    func read(key: String) -> String? {
        // TODO: implement SecItemCopyMatching
        return nil
    }

    func delete(key: String) {
        // TODO: implement SecItemDelete
    }
}
