import Foundation

enum TipsinessCategory: String, CaseIterable {
    case fresh = "Fresh"
    case buzzing = "Buzzing"
    case loose = "Loose"
    case wavy = "Wavy"
    case goneMode = "Gone Mode"
    case unknown = "Unknown"

    init(from percentage: Double) {
        switch percentage {
        case 0..<5:     self = .unknown
        case 5..<20:    self = .fresh
        case 20..<40:   self = .buzzing
        case 40..<65:   self = .loose
        case 65..<85:   self = .wavy
        default:        self = .goneMode
        }
    }

    var emoji: String {
        switch self {
        case .fresh:    return "🙂"
        case .buzzing:  return "😄"
        case .loose:    return "😵‍💫"
        case .wavy:     return "🌊"
        case .goneMode: return "🫠"
        case .unknown:  return "❔"
        }
    }
}
