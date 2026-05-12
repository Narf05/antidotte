import SwiftUI

struct PanicPrivacyBanner: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            if appState.panicPrivacyActive {
                HStack(spacing: 10) {
                    Image(systemName: "eye.slash.fill")
                        .foregroundStyle(Color.antidotteDanger)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Privacy mode active")
                            .font(.subheadline.weight(.semibold))
                        Text("Location and score hidden from all friends")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button("Disable") {
                        appState.deactivatePanicPrivacy()
                    }
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.antidotteDanger)
                }
                .padding(14)
                .background(Color.antidotteDanger.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.antidotteDanger.opacity(0.3), lineWidth: 1))
            } else {
                Button {
                    appState.activatePanicPrivacy()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "eye.slash")
                            .foregroundStyle(.secondary)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Panic privacy")
                                .font(.subheadline.weight(.semibold))
                            Text("Hide location and score for 24h")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(14)
                    .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
        }
    }
}
