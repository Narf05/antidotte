import SwiftUI

struct PassThePhoneView: View {
    let games: [GameType]
    @ObservedObject var viewModel: AlcotestViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var guests: [Guest] = []
    @State private var started = false
    @State private var currentGuestIndex = 0
    @State private var currentGameIndex = 0
    @State private var guestResults: [String: [ActiveTestResult]] = [:]
    @State private var showScoreboard = false

    var body: some View {
        if showScoreboard {
            ScoreboardView(results: allResults) {
                dismiss()
            }
        } else if started {
            playPhase
        } else {
            setupPhase
        }
    }

    private var setupPhase: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    GuestManagerView(guests: $guests)
                        .padding(.top, 8)
                }
            }
            .background(Color.antidotteBackground.ignoresSafeArea())
            .navigationTitle("Pass the phone")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Start") { started = true }
                        .fontWeight(.semibold)
                        .disabled(guests.isEmpty)
                }
            }
        }
    }

    private var playPhase: some View {
        ZStack {
            Color.antidotteBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                playerHeader

                if currentGuestIndex < guests.count && currentGameIndex < games.count {
                    gameView(for: games[currentGameIndex])
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                }
            }
        }
    }

    private var playerHeader: some View {
        HStack(spacing: 12) {
            let guest = guests[min(currentGuestIndex, guests.count - 1)]

            Text(String(guest.name.prefix(2)).uppercased())
                .font(.caption.bold())
                .foregroundStyle(.white)
                .frame(width: 34, height: 34)
                .background(Color.antidotteAccent, in: Circle())

            Text(guest.name)
                .font(.subheadline.weight(.medium))

            Spacer()

            Text("\(currentGuestIndex + 1)/\(guests.count)")
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.antidotteSurface)
    }

    @ViewBuilder
    private func gameView(for game: GameType) -> some View {
        let complete: (ActiveTestResult) -> Void = { result in
            let guestId = guests[currentGuestIndex].id
            guestResults[guestId, default: []].append(result)
            withAnimation { advance() }
        }
        switch game {
        case .tapTheDot:    TapTheDotGame(onComplete: complete)
        case .holdStill:    HoldStillGame(onComplete: complete)
        case .memoryTray:   MemoryTrayGame(onComplete: complete)
        case .straightLine: StraightLineGame(onComplete: complete)
        case .vibeCheck:    VibeCheckGame(onComplete: complete)
        default:            VibeCheckGame(onComplete: complete)
        }
    }

    private func advance() {
        if currentGameIndex + 1 < games.count {
            currentGameIndex += 1
        } else if currentGuestIndex + 1 < guests.count {
            currentGuestIndex += 1
            currentGameIndex = 0
        } else {
            showScoreboard = true
        }
    }

    private var allResults: [ActiveTestResult] {
        guestResults.values.flatMap { $0 }
    }
}
