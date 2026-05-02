import Foundation
import CoreLocation
import Combine

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()

    @Published var currentLocation: CLLocation? = nil
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    private let clManager = CLLocationManager()
    private var uploadTask: Task<Void, Never>?

    private override init() {
        super.init()
        clManager.delegate = self
        clManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        clManager.distanceFilter = 50
        authorizationStatus = clManager.authorizationStatus
    }

    func requestPermission() {
        clManager.requestWhenInUseAuthorization()
    }

    func requestAlwaysPermission() {
        clManager.requestAlwaysAuthorization()
    }

    func startUpdating(backgroundMode: Bool = false) {
        if backgroundMode {
            clManager.desiredAccuracy = kCLLocationAccuracyKilometer
            clManager.distanceFilter = 200
            clManager.allowsBackgroundLocationUpdates = true
            clManager.pausesLocationUpdatesAutomatically = true
            clManager.startMonitoringSignificantLocationChanges()
        } else {
            clManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            clManager.distanceFilter = 50
            clManager.allowsBackgroundLocationUpdates = false
            clManager.startUpdatingLocation()
        }
    }

    func stopUpdating() {
        clManager.stopUpdatingLocation()
        clManager.stopMonitoringSignificantLocationChanges()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        uploadPresence(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Silently ignore location errors; presence simply goes stale on the server
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if manager.authorizationStatus == .authorizedWhenInUse
            || manager.authorizationStatus == .authorizedAlways {
            startUpdating()
        }
    }

    // MARK: - Private

    private func uploadPresence(_ location: CLLocation) {
        uploadTask?.cancel()
        uploadTask = Task {
            try? await APIClient.shared.updatePresence(
                lat: location.coordinate.latitude,
                lon: location.coordinate.longitude,
                accuracyM: location.horizontalAccuracy
            )
        }
    }
}
