import SwiftUI

struct PrivacySummaryView: View {
    let locationEnabled: Bool
    let drunknessVisibility: String
    let panicPrivacyActive: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Privacy", systemImage: "lock.shield.fill")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                privacyPill(
                    label: locationEnabled ? "Location on" : "Location off",
                    icon: locationEnabled ? "location.fill" : "location.slash",
                    active: locationEnabled
                )
                privacyPill(
                    label: drunknessLabel,
                    icon: "gauge.medium",
                    active: drunknessVisibility != "hidden"
                )
                if panicPrivacyActive {
                    privacyPill(label: "Panic mode", icon: "eye.slash.fill", active: false, danger: true)
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 12))
    }

    private var drunknessLabel: String {
        switch drunknessVisibility {
        case "category":   return "Category"
        case "percentage": return "Score %"
        case "both":       return "Score + %"
        default:           return "Score hidden"
        }
    }

    private func privacyPill(label: String, icon: String, active: Bool, danger: Bool = false) -> some View {
        Label(label, systemImage: icon)
            .font(.caption2.weight(.semibold))
            .foregroundStyle(danger ? Color.antidotteDanger : (active ? Color.antidotteAccent : .secondary))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background((danger ? Color.antidotteDanger : (active ? Color.antidotteAccent : Color.gray)).opacity(0.1))
            .clipShape(Capsule())
    }
}
