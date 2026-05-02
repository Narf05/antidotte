import SwiftUI

struct LocationPrecisionButton: View {
    @Binding var precision: LocationPrecision

    private var icon: String {
        switch precision {
        case .exact:           return "location.fill"
        case .approximate150m: return "location.slash.fill"
        case .off:             return "location.slash"
        }
    }

    private var label: String {
        switch precision {
        case .exact:           return "Exact"
        case .approximate150m: return "~150m"
        case .off:             return "Off"
        }
    }

    var body: some View {
        Menu {
            Button { precision = .exact } label: {
                Label("Exact location", systemImage: "location.fill")
            }
            Button { precision = .approximate150m } label: {
                Label("Approximate (~150m)", systemImage: "location.slash.fill")
            }
            Button { precision = .off } label: {
                Label("Off", systemImage: "location.slash")
            }
        } label: {
            Label(label, systemImage: icon)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.thinMaterial, in: Capsule())
                .foregroundStyle(precision == .off ? .secondary : Color.antidotteAccent)
        }
    }
}
