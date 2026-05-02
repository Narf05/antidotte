import SwiftUI

private struct LocationGroup: Identifiable {
    let id: String
    var name: String
    var precision: LocationPrecision
}

struct LocationGroupsView: View {
    @State private var groups: [LocationGroup] = []
    @State private var showAddGroup = false
    @State private var newGroupName = ""

    private let allPrecisions: [LocationPrecision] = [.exact, .approximate150m, .off]

    var body: some View {
        List {
            Section {
                ForEach($groups) { $group in
                    GroupRow(group: $group, allPrecisions: allPrecisions) {
                        save(group: group)
                    }
                }
                .onDelete { offsets in
                    groups.remove(atOffsets: offsets)
                }
            } header: {
                Text("Set a different location precision for each group of friends.")
                    .textCase(nil)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section {
                Button { showAddGroup = true } label: {
                    Label("Add group", systemImage: "plus.circle")
                        .foregroundStyle(Color.antidotteAccent)
                }
            }
        }
        .navigationTitle("Location groups")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { EditButton() }
        .task { await loadGroups() }
        .alert("New group", isPresented: $showAddGroup) {
            TextField("Group name", text: $newGroupName)
            Button("Add") {
                let name = newGroupName.trimmingCharacters(in: .whitespaces)
                guard !name.isEmpty else { return }
                let group = LocationGroup(id: UUID().uuidString, name: name, precision: .approximate150m)
                groups.append(group)
                newGroupName = ""
                save(group: group)
            }
            Button("Cancel", role: .cancel) { newGroupName = "" }
        }
    }

    private func loadGroups() async {
        struct GroupResponse: Decodable {
            let id: String
            let groupName: String
            let precisionMode: String
        }
        let response = try? await APIClient.shared.request(
            .visibilityRules,
            responseType: [GroupResponse].self
        )
        groups = (response ?? []).map { r in
            let precision: LocationPrecision
            switch r.precisionMode {
            case "exact":      precision = .exact
            case "rough_area": precision = .approximate150m
            default:           precision = .off
            }
            return LocationGroup(id: r.id, name: r.groupName, precision: precision)
        }
    }

    private func save(group: LocationGroup) {
        let modeValue: String
        switch group.precision {
        case .exact:          modeValue = "exact"
        case .approximate150m: modeValue = "rough_area"
        case .off:            modeValue = "off"
        }
        Task {
            try? await APIClient.shared.request(
                .updatePresence,
                body: ["groupId": AnyEncodable(group.id), "precisionMode": AnyEncodable(modeValue)]
            )
        }
    }
}

private struct GroupRow: View {
    @Binding var group: LocationGroup
    let allPrecisions: [LocationPrecision]
    let onPrecisionChange: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(group.name).font(.subheadline)
                Text(label(for: group.precision)).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Menu {
                ForEach(allPrecisions.indices, id: \.self) { i in
                    let p = allPrecisions[i]
                    Button { group.precision = p; onPrecisionChange() } label: {
                        if group.precision == i.self as? LocationPrecision {
                            Label(label(for: p), systemImage: "checkmark")
                        } else {
                            Text(label(for: p))
                        }
                    }
                }
            } label: {
                Text(label(for: group.precision))
                    .font(.caption)
                    .foregroundStyle(Color.antidotteAccent)
            }
        }
    }

    private func label(for precision: LocationPrecision) -> String {
        switch precision {
        case .exact:           return "Exact"
        case .approximate150m: return "Approximate"
        case .off:             return "Hidden"
        }
    }
}
