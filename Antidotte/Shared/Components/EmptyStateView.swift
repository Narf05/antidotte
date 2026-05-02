import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String
    var systemImageName: String? = nil
    var actionLabel: String? = nil
    var action: (() -> Void)? = nil

    init(
        title: String = "Nothing here yet",
        message: String,
        systemImageName: String? = nil,
        actionLabel: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.systemImageName = systemImageName
        self.actionLabel = actionLabel
        self.action = action
    }

    var body: some View {
        VStack(spacing: 14) {
            if let systemImageName {
                Image(systemName: systemImageName)
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(Color.antidotteAccent)
                    .accessibilityHidden(true)
            }

            VStack(spacing: 6) {
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let actionLabel, let action {
                Button(actionLabel, action: action)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.regular)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .accessibilityElement(children: .combine)
    }
}
