import Foundation
import CoreMotion

final class MotionProcessor {
    static let shared = MotionProcessor()
    private let motionManager = CMMotionManager()
    private init() {}

    // TODO: collect accelerometer + gyro, derive instability/gait scores
    // Only active when motion_tracking_enabled = true
}
