import SwiftUI

struct JoinStatusToggle: View {
    @Binding var status: JoinStatus

    var body: some View {
        Menu {
            ForEach(JoinStatus.allCases) { option in
                Button {
                    status = option
                } label: {
                    Label(option.label, systemImage: option.systemImageName)
                }
            }
        } label: {
            JoinStatusBadge(status: status)
        }
    }
}
