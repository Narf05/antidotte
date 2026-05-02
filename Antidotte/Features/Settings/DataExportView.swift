import SwiftUI

struct DataExportView: View {
    @State private var showDeleteConfirmation = false
    @State private var deleteSessionsConfirmation = false
    @State private var isExporting = false
    @State private var exportComplete = false
    @State private var errorMessage: String? = nil

    var body: some View {
        List {
            Section {
                Button {
                    Task { await exportData() }
                } label: {
                    HStack {
                        Label("Export my data", systemImage: "square.and.arrow.up")
                            .foregroundStyle(Color.antidotteAccent)
                        Spacer()
                        if isExporting { ProgressView() }
                        if exportComplete { Image(systemName: "checkmark").foregroundStyle(.green) }
                    }
                }
                .disabled(isExporting)
            } footer: {
                Text("Exports all your drink logs, sessions, and scores as a JSON file.")
            }

            Section {
                Button(role: .destructive) {
                    deleteSessionsConfirmation = true
                } label: {
                    Label("Delete session & drink history", systemImage: "trash")
                }
            } footer: {
                Text("Permanently removes all sessions and drink logs. Your account remains active.")
            }

            Section {
                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Label("Delete account", systemImage: "person.crop.circle.badge.xmark")
                }
            } footer: {
                Text("A 30-day grace period applies. You can cancel deletion by logging back in within that window.")
            }

            if let error = errorMessage {
                Section {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("Data & account")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            "Delete all session and drink history?",
            isPresented: $deleteSessionsConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete history", role: .destructive) {
                Task { await deleteHistory() }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This cannot be undone.")
        }
        .confirmationDialog(
            "Delete your account?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Schedule deletion", role: .destructive) {
                Task { await scheduleAccountDeletion() }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Your account will be deleted after a 30-day grace period. Log back in within that window to cancel.")
        }
    }

    private func exportData() async {
        isExporting = true
        errorMessage = nil
        struct ExportResponse: Decodable { let downloadUrl: String }
        do {
            let response = try await APIClient.shared.request(
                .profile,
                responseType: ExportResponse.self
            )
            isExporting = false
            exportComplete = true
            try? await Task.sleep(for: .seconds(2))
            exportComplete = false
        } catch {
            isExporting = false
            errorMessage = "Export failed. Please try again."
        }
    }

    private func deleteHistory() async {
        struct Empty: Decodable {}
        _ = try? await APIClient.shared.request(.drinkLogs, responseType: Empty.self)
    }

    private func scheduleAccountDeletion() async {
        struct Empty: Decodable {}
        _ = try? await APIClient.shared.request(.profile, responseType: Empty.self)
    }
}
