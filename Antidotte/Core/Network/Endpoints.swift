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
    case removeFriend(friendId: String)
    case blockUser(userId: String)
    case searchUsers(query: String)
    case inviteCode
    case generateInviteCode

    // Groups
    case groups
    case createGroup
    case updateGroup(groupId: String)
    case deleteGroup(groupId: String)
    case addGroupMember(groupId: String)
    case removeGroupMember(groupId: String, userId: String)

    // Calibration
    case updateCalibration

    // Sessions
    case sessions
    case createSession
    case session(sessionId: String)
    case updateSession(sessionId: String)
    case endSession(sessionId: String)
    case deleteSession(sessionId: String)

    // Drinks
    case drinkLogs
    case logDrink
    case updateDrink(logId: String)
    case deleteDrink(logId: String)
    case analyzePhoto

    // Location
    case updatePresence
    case friendPresences
    case visibilityRules
    case deleteVisibilityRule(ruleId: String)

    // Score
    case currentScore
    case scoreHistory
    case submitActiveTest

    // Notifications
    case notifications
    case markNotificationRead(id: String)

    var path: String {
        switch self {
        case .register:                         return "/auth/register"
        case .login:                            return "/auth/login"
        case .refreshToken:                     return "/auth/refresh"
        case .logout:                           return "/auth/logout"

        case .profile:                          return "/users/me"
        case .updateProfile:                    return "/users/me"
        case .calibration:                      return "/users/me/calibration"
        case .settings:                         return "/users/me/settings"
        case .searchUsers(let q):               return "/users/search?q=\(q.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? q)"

        case .friends:                          return "/friends"
        case .removeFriend(let id):             return "/friends/\(id)"
        case .friendRequests:                   return "/friends/request"
        case .sendFriendRequest:                return "/friends/request"
        case .respondFriendRequest(let id):     return "/friends/request/\(id)"
        case .blockUser(let id):                return "/friends/block/\(id)"
        case .inviteCode:                       return "/friends/invite-code"
        case .generateInviteCode:               return "/friends/invite-code"

        case .updateCalibration:                return "/users/me/calibration"

        case .groups:                           return "/groups"
        case .createGroup:                      return "/groups"
        case .updateGroup(let id):              return "/groups/\(id)"
        case .deleteGroup(let id):              return "/groups/\(id)"
        case .addGroupMember(let id):           return "/groups/\(id)/members"
        case .removeGroupMember(let gid, let uid): return "/groups/\(gid)/members/\(uid)"

        case .sessions:                         return "/sessions"
        case .createSession:                    return "/sessions"
        case .session(let id):                  return "/sessions/\(id)"
        case .updateSession(let id):            return "/sessions/\(id)"
        case .endSession(let id):               return "/sessions/\(id)/end"
        case .deleteSession(let id):            return "/sessions/\(id)"

        case .drinkLogs:                        return "/drinks"
        case .logDrink:                         return "/drinks"
        case .updateDrink(let id):              return "/drinks/\(id)"
        case .deleteDrink(let id):              return "/drinks/\(id)"
        case .analyzePhoto:                     return "/drinks/analyze-photo"

        case .updatePresence:                   return "/location/presence"
        case .friendPresences:                  return "/location/friends"
        case .visibilityRules:                  return "/location/visibility-rules"
        case .deleteVisibilityRule(let id):     return "/location/visibility-rules/\(id)"

        case .currentScore:                     return "/score/current"
        case .scoreHistory:                     return "/score/history"
        case .submitActiveTest:                 return "/score/active-test"

        case .notifications:                    return "/notifications"
        case .markNotificationRead(let id):     return "/notifications/\(id)/read"
        }
    }

    var method: String {
        switch self {
        case .register, .login, .sendFriendRequest, .inviteCode, .generateInviteCode,
             .createGroup, .addGroupMember, .createSession, .logDrink,
             .analyzePhoto, .updatePresence, .visibilityRules, .submitActiveTest,
             .blockUser, .endSession, .logout:
            return "POST"
        case .updateProfile, .calibration, .updateCalibration, .settings, .respondFriendRequest,
             .updateSession, .updateGroup, .updateDrink, .markNotificationRead:
            return "PATCH"
        case .removeFriend, .deleteGroup, .removeGroupMember, .deleteSession,
             .deleteDrink, .deleteVisibilityRule:
            return "DELETE"
        case .refreshToken:
            return "POST"
        default:
            return "GET"
        }
    }
}
