import SwiftUI

struct FriendsSetupView: View {
    let next: () -> Void

    @State private var searchQuery = ""
    @State private var inviteCode: String? = nil
    @State private var isGeneratingCode = false

    var body: some View {
        VStack(spacing: 0) {
            OnboardingHeader(
                icon: "person.2.fill",
                title: "Add your first friends",
                subtitle: "Search by username or share an invite code. You can add more friends later."
            )

            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 10) {
                        HStack {
                            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                            TextField("Search by username", text: $searchQuery)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        }
                        .padding(14)
                        .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 12))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        }
                    }
                    .padding(.horizontal, 24)

                    Divider().padding(.horizontal, 24)

                    VStack(spacing: 12) {
                        Text("Or invite with a code")
                            .font(.subheadline.weight(.medium))

                        if let code = inviteCode {
                            HStack {
                                Text(code)
                                    .font(.title3.bold().monospaced())
                                    .foregroundStyle(Color.antidotteAccent)
                                Spacer()
                                Button {
                                    UIPasteboard.general.string = code
                                } label: {
                                    Label("Copy", systemImage: "doc.on.doc")
                                        .font(.caption)
                                }
                                .buttonStyle(.bordered)
                            }
                            .padding(14)
                            .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal, 24)

                            Text("Code expires in 7 days.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        } else {
                            Button {
                                generateCode()
                            } label: {
                                if isGeneratingCode {
                                    ProgressView()
                                } else {
                                    Label("Generate invite code", systemImage: "link")
                                        .font(.subheadline.weight(.medium))
                                }
                            }
                            .buttonStyle(.bordered)
                            .disabled(isGeneratingCode)
                        }
                    }
                }
                .padding(.vertical, 8)
            }

            OnboardingContinueButton(label: "Continue") { next() }
        }
        .background(Color.antidotteBackground.ignoresSafeArea())
    }

    private func generateCode() {
        isGeneratingCode = true
        Task {
            struct CodeResponse: Decodable { let code: String }
            let resp = try? await APIClient.shared.request(.inviteCode, responseType: CodeResponse.self)
            await MainActor.run {
                inviteCode = resp?.code
                isGeneratingCode = false
            }
        }
    }
}
