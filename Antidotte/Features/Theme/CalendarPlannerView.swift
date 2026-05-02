import SwiftUI

struct CalendarPlannerView: View {
    @State private var sessions: [PlannedSession] = []
    @State private var showAddSheet = false
    @State private var newTitle = ""
    @State private var newDate = Date()
    @State private var isLoading = false

    var body: some View {
        List {
            Section {
                Button { showAddSheet = true } label: {
                    Label("Plan a session", systemImage: "calendar.badge.plus")
                        .foregroundStyle(Color.antidotteAccent)
                }
            }

            Section("Planned") {
                if sessions.filter({ !$0.isPast }).isEmpty {
                    Text("No upcoming sessions planned.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(sessions.filter { !$0.isPast }) { session in
                        SessionPlanRow(session: session)
                    }
                    .onDelete { offsets in
                        sessions.remove(atOffsets: offsets)
                    }
                }
            }

            let past = sessions.filter { $0.isPast }
            if !past.isEmpty {
                Section("Past") {
                    ForEach(past) { session in
                        SessionPlanRow(session: session)
                    }
                }
            }
        }
        .navigationTitle("Planner")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { EditButton() }
        .task { await loadSessions() }
        .sheet(isPresented: $showAddSheet) {
            addSheet
        }
    }

    private var addSheet: some View {
        NavigationStack {
            Form {
                Section("Session name") {
                    TextField("e.g. Friday night out", text: $newTitle)
                }
                Section("Date") {
                    DatePicker("Date & time", selection: $newDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                }
            }
            .navigationTitle("Plan session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { showAddSheet = false }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        guard !newTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                        sessions.append(PlannedSession(id: UUID().uuidString, title: newTitle, date: newDate))
                        sessions.sort { $0.date < $1.date }
                        showAddSheet = false
                        newTitle = ""
                        newDate = Date()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium])
    }

    private func loadSessions() async {
        isLoading = true
        struct SessionResponse: Decodable {
            let id: String
            let title: String
            let startedAt: String
        }
        let response = try? await APIClient.shared.request(
            .sessions,
            responseType: [SessionResponse].self
        )
        let df = ISO8601DateFormatter()
        sessions = (response ?? []).compactMap { r in
            guard let d = df.date(from: r.startedAt) else { return nil }
            return PlannedSession(id: r.id, title: r.title, date: d)
        }
        isLoading = false
    }
}

private struct PlannedSession: Identifiable {
    let id: String
    let title: String
    let date: Date

    var isPast: Bool { date < Date() }
}

private struct SessionPlanRow: View {
    let session: PlannedSession

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .center, spacing: 0) {
                Text(session.date, format: .dateTime.day())
                    .font(.title3.bold())
                Text(session.date, format: .dateTime.month(.abbreviated))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 40)

            VStack(alignment: .leading, spacing: 2) {
                Text(session.title).font(.subheadline)
                Text(session.date, style: .time).font(.caption).foregroundStyle(.secondary)
            }
        }
    }
}
