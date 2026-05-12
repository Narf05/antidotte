import SwiftUI
import CoreLocation

struct LocationPermissionView: View {
    let next: () -> Void

    @StateObject private var locationManager = LocationManager.shared

    var body: some View {
        VStack(spacing: 0) {
            OnboardingHeader(
                icon: "location.fill",
                title: "Location sharing",
                subtitle: "Share your location with friends on the live map. You can turn this on or off any time."
            )

            Spacer()

            VStack(spacing: 20) {
                Image(systemName: "map.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(Color.antidotteAccent)

                VStack(spacing: 8) {
                    Text("Friends see where you are")
                        .font(.headline)
                    Text("Only accepted friends can see your location. You control the precision — exact or blurred to 150m.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 32)
                }
            }

            Spacer()

            VStack(spacing: 12) {
                if locationManager.authorizationStatus == .denied {
                    Text("Location access was denied. Open Settings to enable it.")
                        .font(.caption)
                        .foregroundStyle(Color.antidotteDanger)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)

                    Button("Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color.antidotteAccent)
                } else {
                    OnboardingContinueButton(label: "Enable location") {
                        locationManager.requestPermission()
                    }
                }

                Button("Skip for now") { next() }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 40)
        }
        .background(Color.antidotteBackground.ignoresSafeArea())
        .onChange(of: locationManager.authorizationStatus) { _, status in
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                next()
            }
        }
    }
}
