import SwiftUI

enum GameType: String, CaseIterable {
    case tapTheDot    = "tap_the_dot"
    case straightLine = "straight_line"
    case memoryTray   = "memory_tray"
    case holdStill    = "hold_still"
    case readItRight  = "read_it_right"
    case tongueTwister = "tongue_twister"
    case vibeCheck    = "vibe_check"
}

struct TapTheDotGame: View {
    let onComplete: (ActiveTestResult) -> Void

    var body: some View {
        // TODO: dot appears at random positions, measure reaction time and accuracy
        EmptyView()
    }
}
