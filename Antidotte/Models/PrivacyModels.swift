import Foundation
import SwiftData

@Model
final class PrivacyConsent {
    var id: String
    var userId: String
    var consentType: String
    var status: String
    var source: String
    var createdAt: Date
    var revokedAt: Date?
    var policyVersion: String

    init(id: String = UUID().uuidString, userId: String, consentType: String, status: String, source: String) {
        self.id = id
        self.userId = userId
        self.consentType = consentType
        self.status = status
        self.source = source
        self.createdAt = Date()
        self.policyVersion = "v1"
    }
}

@Model
final class PrivacyAuditEvent {
    var id: String
    var userId: String
    var actorUserId: String?
    var eventType: String
    var createdAt: Date
    var metadataJSON: String?

    init(id: String = UUID().uuidString, userId: String, eventType: String) {
        self.id = id
        self.userId = userId
        self.eventType = eventType
        self.createdAt = Date()
    }
}
