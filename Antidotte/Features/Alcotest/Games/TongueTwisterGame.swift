import SwiftUI
import AVFoundation
import Speech

struct TongueTwisterGame: View {
    let onComplete: (ActiveTestResult) -> Void

    @State private var currentIndex = 0
    @State private var phase: Phase = .show
    @State private var transcript = ""
    @State private var isRecording = false
    @State private var scores: [Double] = []
    @State private var recognitionTask: SFSpeechRecognitionTask?
    @State private var audioEngine = AVAudioEngine()
    @State private var permissionDenied = false

    private let twisters = [
        "Red lorry, yellow lorry",
        "Unique New York",
        "Peter Piper picked a peck of pickled peppers",
    ]

    enum Phase { case show, record, next }

    var current: String { twisters[currentIndex] }

    var body: some View {
        ZStack {
            Color.antidotteBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                progressBar

                Spacer()

                switch phase {
                case .show:   showPhase
                case .record: recordPhase
                case .next:   EmptyView()
                }

                Spacer()
            }
        }
        .onDisappear { stopRecording() }
    }

    private var progressBar: some View {
        HStack(spacing: 6) {
            ForEach(0..<twisters.count, id: \.self) { i in
                Capsule()
                    .fill(i < scores.count ? Color.antidotteAccent : Color.gray.opacity(0.25))
                    .frame(height: 4)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    private var showPhase: some View {
        VStack(spacing: 28) {
            Text("Say this:")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("\"\(current)\"")
                .font(.title3.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(16)
                .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 24)

            if permissionDenied {
                Text("Microphone or speech recognition access required.")
                    .font(.caption)
                    .foregroundStyle(.orange)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Button { Task { await startRecording() } } label: {
                Label("Record", systemImage: "mic.fill")
                    .font(.headline)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(Color.antidotteAccent)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
            .disabled(permissionDenied)
        }
    }

    private var recordPhase: some View {
        VStack(spacing: 28) {
            Circle()
                .fill(Color.red.opacity(0.12))
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: "mic.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(.red)
                )
                .scaleEffect(isRecording ? 1.06 : 1.0)
                .animation(.easeInOut(duration: 0.5).repeatForever(), value: isRecording)

            Text("\"\(current)\"")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            if !transcript.isEmpty {
                Text(transcript)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Button {
                stopRecording()
                let score = calculateScore(spoken: transcript, target: current)
                scores.append(score)
                transcript = ""
                if currentIndex + 1 < twisters.count {
                    currentIndex += 1
                    phase = .show
                } else {
                    finishGame()
                }
            } label: {
                Text("Next")
                    .font(.headline)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(Color.antidotteSurface)
                    .clipShape(Capsule())
            }
        }
    }

    private func startRecording() async {
        let speechGranted = await SFSpeechRecognizer.requestAuthorization() == .authorized
        let micGranted: Bool
        if #available(iOS 17.0, *) {
            micGranted = await AVAudioApplication.requestRecordPermission()
        } else {
            micGranted = await withCheckedContinuation { cont in
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    cont.resume(returning: granted)
                }
            }
        }

        guard speechGranted && micGranted else {
            permissionDenied = true
            return
        }

        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true

        let node = audioEngine.inputNode
        let format = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: format) { buf, _ in
            request.append(buf)
        }
        audioEngine.prepare()
        try? audioEngine.start()

        recognitionTask = recognizer?.recognitionTask(with: request) { result, _ in
            if let result { transcript = result.bestTranscription.formattedString }
        }

        isRecording = true
        phase = .record
    }

    private func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.cancel()
        recognitionTask = nil
        isRecording = false
    }

    private func calculateScore(spoken: String, target: String) -> Double {
        let targetWords = target.lowercased().components(separatedBy: .whitespaces)
        let spokenWords = spoken.lowercased().components(separatedBy: .whitespaces)
        let matches = targetWords.filter { spokenWords.contains($0) }.count
        return Double(matches) / Double(max(1, targetWords.count)) * 100.0
    }

    private func finishGame() {
        let avg = scores.isEmpty ? 50.0 : scores.reduce(0, +) / Double(scores.count)
        let result = ActiveTestResult(
            id: UUID().uuidString,
            userId: "",
            gameType: GameType.tongueTwister.rawValue,
            rawScore: avg,
            normalizedScore: avg,
            completedAt: Date()
        )
        result.confidence = 0.75
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { onComplete(result) }
    }
}
