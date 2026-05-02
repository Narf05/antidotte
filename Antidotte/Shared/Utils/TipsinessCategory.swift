import Foundation
import SwiftUI

enum TipsinessCategory: String, CaseIterable, Identifiable, Codable {
    case unknown = "Unknown"
    case fresh = "Fresh"
    case buzzing = "Buzzing"
    case loose = "Loose"
    case wavy = "Wavy"
    case goneMode = "Gone Mode"

    var id: String { rawValue }

    init(from percentage: Double?) {
        guard let percentage else {
            self = .unknown
            return
        }

        switch percentage {
        case ..<5:      self = .unknown
        case 5..<20:    self = .fresh
        case 20..<40:   self = .buzzing
        case 40..<65:   self = .loose
        case 65..<85:   self = .wavy
        default:        self = .goneMode
        }
    }

    init(from percentage: Double) {
        self.init(from: Optional(percentage))
    }

    var label: String { rawValue }

    var accessibilityLabel: String {
        switch self {
        case .unknown: return "No reliable score yet"
        case .fresh: return "Fresh"
        case .buzzing: return "Buzzing"
        case .loose: return "Loose"
        case .wavy: return "Wavy"
        case .goneMode: return "Gone mode"
        }
    }

    var systemImageName: String {
        switch self {
        case .unknown: return "questionmark.circle"
        case .fresh: return "leaf"
        case .buzzing: return "sparkles"
        case .loose: return "waveform.path.ecg"
        case .wavy: return "water.waves"
        case .goneMode: return "exclamationmark.triangle"
        }
    }

    var emoji: String {
        switch self {
        case .unknown: return "?"
        case .fresh: return "F"
        case .buzzing: return "B"
        case .loose: return "L"
        case .wavy: return "W"
        case .goneMode: return "G"
        }
    }

    var color: Color {
        switch self {
        case .unknown: return .tipsUnknown
        case .fresh: return .tipsFresh
        case .buzzing: return .tipsBuzzing
        case .loose: return .tipsLoose
        case .wavy: return .tipsWavy
        case .goneMode: return .tipsGoneMode
        }
    }

    var percentageRangeLabel: String {
        switch self {
        case .unknown: return "0-4%"
        case .fresh: return "5-19%"
        case .buzzing: return "20-39%"
        case .loose: return "40-64%"
        case .wavy: return "65-84%"
        case .goneMode: return "85-100%"
        }
    }
}
