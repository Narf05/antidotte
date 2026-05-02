import Foundation

enum Endpoint {
    // Auth
    case register
    case login
    case refreshToken
    case logout

    // Users
    case profile
    case updateProfile
    case calibration
    case settings

    // Friends
    case friendRequests
    case sendFriendRequest(userId: String)
    case respondFriendRequest(requestId: String)
    case friends
    case blockUser(userId: String)
    case searchUsers(query: String)

    // Groups
    case groups
    case createGroup
    case updateGroup(groupId: String)
    case deleteGroup(groupId: String)

    // Sessions
    case sessions
    case createSession
    case updateSession(sessionId: String)
    case endSession(sessionId: String)

    // Drinks
    case drinkLogs
    case logDrink
    case deleteDrink(logId: String)
    case analyzePhoto

    // Location
    case updatePresence
    case visibilityRules

    // Score
    case scoreSnapshots
    case submitActiveTest

    // Notifications
    case notifications
    case markNotificationRead(id: String)

    var path: String {
        // TODO: return path string per case
        return ""
    }
}
