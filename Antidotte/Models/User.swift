import Foundation
import SwiftData

@Model
final class User {
    var id: String
    var username: String
    var displayName: String
    var profileImageURL: String?
    var languageCode: String
    var isSearchable: Bool
    var ageVerifiedAt: Date?
    var bodyWeightKg: Double
    var drinkUnitDefinition: String
    var usualRefreshmentsPerSession: Double?
    var usualSessionsPerWeek: Double?
    var sports: String?
    var heightCm: Double?
    var toleranceSelfRating: String?
    var styleMode: String
    var drunknessVisibility: String
    var locationSharingEnabled: Bool
    var locationPrecision: String
    var shareWhenAppClosed: Bool
    var showMeOnFriendMap: Bool
    var scoreSharingEnabled: Bool
    var motionTrackingEnabled: Bool
    var phoneUsageTrackingEnabled: Bool
    var voiceAnalysisEnabled: Bool
    var messageAnalysisEnabled: Bool
    var photoRefreshmentDetectionEnabled: Bool
    var saveRefreshmentPhotosEnabled: Bool
    var photoAnalysisDefault: String
    var notificationsEnabled: Bool
    var panicPrivacyActive: Bool
    var panicPrivacyExpiresAt: Date?
    var createdAt: Date
    var updatedAt: Date

    init(id: String, username: String, displayName: String, bodyWeightKg: Double) {
        self.id = id
        self.username = username
        self.displayName = displayName
        self.languageCode = AppLanguage.english.rawValue
        self.isSearchable = true
        self.bodyWeightKg = bodyWeightKg
        self.drinkUnitDefinition = "small_refreshment"
        self.styleMode = "chaos"
        self.drunknessVisibility = "percentage"
        self.locationSharingEnabled = false
        self.locationPrecision = VisibilityLevel.hidden.rawValue
        self.shareWhenAppClosed = false
        self.showMeOnFriendMap = false
        self.scoreSharingEnabled = false
        self.motionTrackingEnabled = false
        self.phoneUsageTrackingEnabled = false
        self.voiceAnalysisEnabled = false
        self.messageAnalysisEnabled = false
        self.photoRefreshmentDetectionEnabled = false
        self.saveRefreshmentPhotosEnabled = false
        self.photoAnalysisDefault = "quick_log"
        self.notificationsEnabled = true
        self.panicPrivacyActive = false
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
