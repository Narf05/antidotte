import SwiftUI
import Charts

struct StatsView: View {
    @StateObject private var viewModel = StatsViewModel()
    @State private var selectedSession: NightOutSession? = nil
    @State private var showFilters = false
    @State private var minScore: Double = 0
    @State private var maxScore: Double = 100
    @State private var selectedDrinkType: String? = nil

    var filteredSessions: [NightOutSession] {
        viewModel.sessions.filter { session in
            guard let peak = session.peakPercentage else { return true }
            return peak >= minScore && peak <= maxScore
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Time range picker
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(StatsViewModel.TimeRange.allCases, id: \.self) { range in
                                Button {
                                    viewModel.selectedRange = range
                                    viewModel.loadData()
                                } label: {
                                    Text(range.rawValue)
                                        .font(.caption.weight(.semibold))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(viewModel.selectedRange == range ? Color.antidotteAccent : Color.antidotteSurface)
                                        .foregroundStyle(viewModel.selectedRange == range ? .white : .primary)
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)
                    }

                    // Key stats
                    if !viewModel.scoreHistory.isEmpty || !viewModel.sessions.isEmpty {
                        KeyStatsView(scoreHistory: viewModel.scoreHistory, sessions: viewModel.sessions)
                            .padding(.horizontal, 20)
                    }

                    // Score chart
                    if !viewModel.scoreHistory.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Score history")
                                .font(.subheadline.weight(.semibold))
                                .padding(.horizontal, 20)

                            ScoreChartView(data: viewModel.scoreHistory, range: viewModel.selectedRange)
                                .padding(.horizontal, 20)
                        }
                        .padding(.vertical, 16)
                        .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 20)
                    } else {
                        EmptyStateView(
                            title: "No data yet",
                            message: "Log drinks and run tests to build your history.",
                            systemImageName: "chart.line.uptrend.xyaxis"
                        )
                    }

                    // Sessions history feed
                    if !filteredSessions.isEmpty {
                        HistoryFeedView(sessions: filteredSessions) { session in
                            selectedSession = session
                        }
                    }
                }
                .padding(.vertical, 16)
            }
            .background(Color.antidotteBackground.ignoresSafeArea())
            .navigationTitle("Stats")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showFilters = true } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundStyle(Color.antidotteAccent)
                    }
                }
            }
            .navigationDestination(item: $selectedSession) { session in
                SessionDetailView(session: session)
            }
            .sheet(isPresented: $showFilters) {
                FiltersView(
                    minScore: $minScore,
                    maxScore: $maxScore,
                    selectedDrinkType: $selectedDrinkType
                )
            }
        }
        .onAppear { viewModel.loadData() }
    }
}
