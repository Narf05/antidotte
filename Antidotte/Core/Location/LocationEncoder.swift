import Foundation
import CoreLocation

enum LocationPrecision {
    case exact
    case approximate150m
    case off
}

struct LocationEncoder {
    // Blurs coordinates to ~150m by rounding to 3 decimal places (~111m grid)
    static func encode(_ location: CLLocation, precision: LocationPrecision) -> CLLocationCoordinate2D? {
        switch precision {
        case .exact:
            return location.coordinate
        case .approximate150m:
            let lat = (location.coordinate.latitude * 1000).rounded() / 1000
            let lon = (location.coordinate.longitude * 1000).rounded() / 1000
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        case .off:
            return nil
        }
    }
}
