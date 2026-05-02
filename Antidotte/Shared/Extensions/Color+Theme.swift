import Foundation
import SwiftUI

enum AntidotteStyleMode: String, CaseIterable, Identifiable {
    case chaos
    case cartoon
    case blackout

    var id: String { rawValue }

    var label: String {
        switch self {
        case .chaos: return "Chaos"
        case .cartoon: return "Cartoon"
        case .blackout: return "Blackout"
        }
    }
}

extension Color {
    static let antidottePrimary = Color(red: 0.08, green: 0.10, blue: 0.14)
    static let antidotteBackground = Color(red: 0.97, green: 0.97, blue: 0.94)
    static let antidotteSurface = Color(red: 1.00, green: 1.00, blue: 0.98)
    static let antidotteAccent = Color(red: 0.12, green: 0.64, blue: 0.54)
    static let antidotteWarning = Color(red: 0.92, green: 0.45, blue: 0.18)
    static let antidotteDanger = Color(red: 0.78, green: 0.16, blue: 0.20)

    static let tipsUnknown = Color.gray
    static let tipsFresh = Color(red: 0.20, green: 0.70, blue: 0.42)
    static let tipsBuzzing = Color(red: 0.86, green: 0.70, blue: 0.20)
    static let tipsLoose = Color(red: 0.90, green: 0.46, blue: 0.18)
    static let tipsWavy = Color(red: 0.78, green: 0.20, blue: 0.26)
    static let tipsGoneMode = Color(red: 0.50, green: 0.28, blue: 0.68)

    static func antidotteAccent(for styleMode: AntidotteStyleMode) -> Color {
        switch styleMode {
        case .chaos: return .antidotteAccent
        case .cartoon: return Color(red: 0.18, green: 0.42, blue: 0.92)
        case .blackout: return Color(red: 0.86, green: 0.86, blue: 0.78)
        }
    }

    static func antidotteBackground(for styleMode: AntidotteStyleMode) -> Color {
        switch styleMode {
        case .chaos: return .antidotteBackground
        case .cartoon: return Color(red: 0.98, green: 0.95, blue: 0.86)
        case .blackout: return Color(red: 0.03, green: 0.03, blue: 0.04)
        }
    }

    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)

        let red: UInt64
        let green: UInt64
        let blue: UInt64
        let alpha: UInt64

        switch cleaned.count {
        case 8:
            red = (value & 0xff00_0000) >> 24
            green = (value & 0x00ff_0000) >> 16
            blue = (value & 0x0000_ff00) >> 8
            alpha = value & 0x0000_00ff
        case 6:
            red = (value & 0xff0000) >> 16
            green = (value & 0x00ff00) >> 8
            blue = value & 0x0000ff
            alpha = 255
        default:
            red = 0
            green = 0
            blue = 0
            alpha = 255
        }

        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: Double(alpha) / 255
        )
    }
}
