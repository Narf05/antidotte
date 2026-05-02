import Foundation
import SwiftData

@Model
final class FriendRequest {
    var id: String
    var requesterUserId: String
    var recipientUserId: String
    var source: String
    var status: String
    var message: String?
    var createdAt: Date
    var respondedAt: Date?

    init(id: String = UUID().uuidString, requesterUserId: String, recipientUserId: String, source: String) {
        self.id = id
        self.requesterUserId = requesterUserId
        self.recipientUserId = recipientUserId
        self.source = source
        self.status = FriendRequestStatus.pending.rawValue
        self.createdAt = Date()
    }
}

@Model
final class Friendship {
    var id: String
    var userAId: String
    var userBId: String
    var status: String
    var createdAt: Date
    var updatedAt: Date

    init(id: String = UUID().uuidString, userAId: String, userBId: String) {
        self.id = id
        self.userAId = userAId
        self.userBId = userBId
        self.status = "active"
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

@Model
final class FriendInviteCode {
    var id: String
    var userId: String
    var codeHash: String
    var createdAt: Date
    var expiresAt: Date?
    var revokedAt: Date?

    init(id: String = UUID().uuidString, userId: String, codeHash: String) {
        self.id = id
        self.userId = userId
        self.codeHash = codeHash
        self.createdAt = Date()
        self.expiresAt = Calendar.current.date(byAdding: .day, value: 3, to: Date())
    }
}

@Model
final class FriendGroup {
    var id: String
    var ownerUserId: String
    var name: String
    var groupDescription: String?
    var visibility: String
    var createdAt: Date
    var updatedAt: Date

    init(id: String = UUID().uuidString, ownerUserId: String, name: String) {
        self.id = id
        self.ownerUserId = ownerUserId
        self.name = name
        self.visibility = GroupVisibility.private.rawValue
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

@Model
final class FriendGroupMember {
    var id: String
    var groupId: String
    var userId: String
    var role: String
    var status: String
    var joinedAt: Date?
    var createdAt: Date

    init(id: String = UUID().uuidString, groupId: String, userId: String) {
        self.id = id
        self.groupId = groupId
        self.userId = userId
        self.role = "member"
        self.status = "active"
        self.joinedAt = Date()
        self.createdAt = Date()
    }
}

@Model
final class UserBlock {
    var id: String
    var blockerUserId: String
    var blockedUserId: String
    var createdAt: Date
    var reason: String?

    init(id: String = UUID().uuidString, blockerUserId: String, blockedUserId: String) {
        self.id = id
        self.blockerUserId = blockerUserId
        self.blockedUserId = blockedUserId
        self.createdAt = Date()
    }
}

@Model
final class SessionInvite {
    var id: String
    var sessionId: String
    var senderUserId: String
    var recipientUserId: String?
    var recipientGroupId: String?
    var status: String
    var createdAt: Date
    var respondedAt: Date?

    init(id: String = UUID().uuidString, sessionId: String, senderUserId: String) {
        self.id = id
        self.sessionId = sessionId
        self.senderUserId = senderUserId
        self.status = FriendRequestStatus.pending.rawValue
        self.createdAt = Date()
    }
}

@Model
final class SocialNotification {
    var id: String
    var recipientUserId: String
    var actorUserId: String?
    var type: String
    var relatedId: String?
    var createdAt: Date
    var readAt: Date?
    var deliveredAt: Date?

    init(id: String = UUID().uuidString, recipientUserId: String, type: NotificationKind) {
        self.id = id
        self.recipientUserId = recipientUserId
        self.type = type.rawValue
        self.createdAt = Date()
    }
}

@Model
final class FriendNotificationSetting {
    var id: String
    var ownerUserId: String
    var friendUserId: String
    var nearbyFriendEnabled: Bool
    var startsRefreshingEnabled: Bool
    var sessionStartedEnabled: Bool
    var updatedAt: Date

    init(id: String = UUID().uuidString, ownerUserId: String, friendUserId: String) {
        self.id = id
        self.ownerUserId = ownerUserId
        self.friendUserId = friendUserId
        self.nearbyFriendEnabled = false
        self.startsRefreshingEnabled = false
        self.sessionStartedEnabled = true
        self.updatedAt = Date()
    }
}
