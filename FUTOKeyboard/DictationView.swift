import SwiftUI

struct DictationView: View {
    @EnvironmentObject var settings: KeyboardSettings
    @State private var downloadedLanguage = true
    @State private var downloadProgress = 1.0
    @State private var activeEngine = "Whisper Offline Small"
    
    var body: some View {
        Form {
            Section(header: Text("Offline Speech-to-Text")) {
                HStack {
                    Image(systemName: "mic.badge.checkmark.fill")
                        .foregroundColor(.orange)
                        .font(.title2)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Whisper Voice Recognition")
                            .bold()
                        Text("FUTO voice typing processes speech 100% locally on your neural engine.")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 6)
            }
            
            Section(header: Text("Model Management")) {
                Picker("Active Speech Engine", selection: $activeEngine) {
                    Text("Whisper Small (38MB)").tag("Whisper Offline Small")
                    Text("Whisper Base (74MB)").tag("Whisper Offline Base")
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("English Language Pack")
                            .font(.body)
                        Text("Downloaded & ready for offline dictation")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Spanish Language Pack")
                            .font(.body)
                            .foregroundColor(.primary)
                        Text("Cloud download: 42.1 MB")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Button("Download") {
                        // Triggers mock download
                    }
                    .font(.caption)
                    .buttonStyle(.bordered)
                }
            }
            
            Section(header: Text("Privacy Advantage")) {
                Text("Standard iOS dictation uploads your audio recordings to Apple's cloud servers for speech processing. FUTO Keyboard performs voice transcription directly on-device using the Apple Neural Engine, meaning your spoken secrets never leave your device.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Offline Voice Typing")
        .navigationBarTitleDisplayMode(.inline)
    }
}
