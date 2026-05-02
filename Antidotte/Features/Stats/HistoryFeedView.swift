import SwiftUI

struct HistoryFeedView: View {
    let sessions: [NightOutSession]
    let onSelectSession: (NightOutSession) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sessions")
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 20)

            ForEach(sessions) { session in
                Button { onSelectSession(session) } label: {
                    SessionRow(session: session)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
            }
        }
    }
}

private struct SessionRow: View {
    let session: NightOutSession

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 5) {
                Text(session.title)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                HStack(spacing: 10) {
                    Label("\(session.refreshmentCount)", systemImage: "wineglass")
                    if let spend = session.totalSpendAmount, let currency = session.spendCurrency {
                        Label(String(format: "%@ %.0f", currencySymbol(currency), spend), systemImage: "eurosign.circle")
                    }
                    if let city = session.primaryCity {
                        Label(city, systemImage: "location")
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                .labelStyle(.titleAndIcon)

                Text(session.startedAt, style: .date)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            if let peak = session.peakPercentage {
                TipsinessBadge(percentage: peak, showLabel: false, showPercentage: true, compact: true)
            }

            Image(systemName: "chevron.right")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(14)
        .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 12))
    }

    private func currencySymbol(_ code: String) -> String {
        let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.currencyCode.rawValue: code]))
        return locale.currencySymbol ?? code
    }
}
