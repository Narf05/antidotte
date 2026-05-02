import SwiftUI
import AVFoundation
import Speech

struct ReadItRightGame: View {
    let onComplete: (ActiveTestResult) -> Void

    @State private var phase: Phase = .instructions
    @State private var transcript = ""
    @State private var isRecording = false
    @State private var recognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    @State private var recognitionTask: SFSpeechRecognitionTask?
    @State private var audioEngine = AVAudioEngine()
    @State private var permissionDenied = false

    private let phrase = "She sells seashells by the seashore"

    enum Phase { case instructions, recording, result }

    var body: some View {
        ZStack {
            Color.antidotteBackground.ignoresSafeArea()

            switch phase {
            case .instructions:
                instructionsView
            case .recording:
                recordingView
            case .result:
                resultView
            }
        }
        .onDisappear { stopRecording() }
    }

    private var instructionsView: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "mic.fill")
                .font(.system(size: 56))
                .foregroundStyle(Color.antidotteAccent)

            VStack(spacing: 12) {
                Text("Read it right")
                    .font(.title2.bold())
                Text("Read the phrase aloud as clearly as you can.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Text("\"\(phrase)\"")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(16)
                .background(Color.antidotteSurface, in: RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 24)

            Spacer()

            if permissionDenied {
                Text("Microphone or speech recognition access required.")
                    .font(.caption)
                    .foregroundStyle(.orange)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Button { Task { await startRecording() } } label: {
                Label("Start recording", systemImage: "mic")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.antidotteAccent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
            .disabled(permissionDenied)
        }
    }

    private var recordingView: some View {
        VStack(spacing: 32) {
            Spacer()

            Circle()
                .fill(Color.red.opacity(0.15))
                .frame(width: 120, height: 120)
                .overlay(
                    Image(systemName: "mic.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(.red)
                )
                .scaleEffect(isRecording ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 0.6).repeatForever(), value: isRecording)

            Text("Recording… read aloud:")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("\"\(phrase)\"")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            if !transcript.isEmpty {
                Text(transcript)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 32)
            }

            Spacer()

            Button {
                stopRecording()
                scoreAndFinish()
            } label: {
                Text("Done")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.antidotteSurface)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }

    private var resultView: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(Color.antidotteAccent)
            Text("Analysis complete")
                .font(.title2.bold())
            Spacer()
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

        phase = .recording
        isRecording = true
    }

    private func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.cancel()
        recognitionTask = nil
        isRecording = false
    }

    private func scoreAndFinish() {
        let target = phrase.lowercased().components(separatedBy: .whitespaces)
        let spoken = transcript.lowercased().components(separatedBy: .whitespaces)
        let matchCount = target.filter { spoken.contains($0) }.count
        let ratio = Double(matchCount) / Double(max(1, target.count))
        let normalized = ratio * 100.0

        let result = ActiveTestResult(
            id: UUID().uuidString,
            userId: "",
            gameType: GameType.readItRight.rawValue,
            rawScore: ratio,
            normalizedScore: normalized,
            completedAt: Date()
        )
        result.confidence = 0.7
        phase = .result
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { onComplete(result) }
    }
}
