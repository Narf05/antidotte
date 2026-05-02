import Foundation

enum AppLanguage: String, Codable, CaseIterable, Identifiable {
    case english = "en"
    case french = "fr"
    case german = "de"
    case croatian = "hr"
    case spanish = "es"

    var id: String { rawValue }
}

enum VisibilityLevel: String, Codable, CaseIterable, Identifiable {
    case exact
    case roughArea = "rough_area"
    case venueOnly = "venue_only"
    case hidden
    case `private`
    case friends
    case group
    case inviteOnly = "invite_only"

    var id: String { rawValue }
}

enum SessionStatus: String, Codable, CaseIterable, Identifiable {
    case planned
    case active
    case ended
    case cancelled

    var id: String { rawValue }
}

enum RefreshmentLogSource: String, Codable, CaseIterable, Identifiable {
    case plusOne = "plus_one"
    case manual
    case imported
    case corrected
    case photoDetected = "photo_detected"

    var id: String { rawValue }
}

enum PriceSource: String, Codable, CaseIterable, Identifiable {
    case userEntered = "user_entered"
    case venueAverage = "venue_average"
    case photoDetected = "photo_detected"
    case receiptDetected = "receipt_detected"

    var id: String { rawValue }
}

enum LocationSource: String, Codable, CaseIterable, Identifiable {
    case gps
    case wifi
    case cell
    case manual
    case venueCheckin = "venue_checkin"
    case none

    var id: String { rawValue }
}

enum PresenceState: String, Codable, CaseIterable, Identifiable {
    case live
    case stale
    case hidden
    case locationOff = "location_off"

    var id: String { rawValue }
}

enum ActiveTestType: String, Codable, CaseIterable, Identifiable {
    case reaction
    case balance
    case coordination
    case typing
    case voice
    case memory
    case focus
    case movement

    var id: String { rawValue }
}

enum FriendRequestStatus: String, Codable, CaseIterable, Identifiable {
    case pending
    case accepted
    case declined
    case cancelled
    case blocked

    var id: String { rawValue }
}

enum GroupVisibility: String, Codable, CaseIterable, Identifiable {
    case `private`
    case shared

    var id: String { rawValue }
}

enum NotificationKind: String, Codable, CaseIterable, Identifiable {
    case friendRequest = "friend_request"
    case friendAccepted = "friend_accepted"
    case groupInvite = "group_invite"
    case sessionInvite = "session_invite"
    case sessionStarted = "session_started"
    case nearbyFriend = "nearby_friend"
    case startsRefreshing = "starts_refreshing"
    case privacyEvent = "privacy_event"

    var id: String { rawValue }
}
