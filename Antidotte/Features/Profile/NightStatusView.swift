import SwiftUI

struct NightStatusView: View {
    var sessionTitle: String? = nil
    var drinkCount: Int = 0
    var joinStatus: JoinStatus = .joinMe
    var locationPrecision: LocationPrecision = .exact

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title = sessionTitle {
                Label(title, systemImage: "moon.stars.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.antidotteAccent)
            }

            HStack(spacing: 16) {
                Label("\(drinkCount) drink\(drinkCount == 1 ? "" : "s")", systemImage: "takeoutbag.and.cup.and.straw.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Divider().frame(height: 14)

                JoinStatusBadge(status: joinStatus, compact: true)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 12))
    }
}
