import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: KeyboardSettings
    
    let layouts = ["QWERTY", "QWERTZ", "AZERTY"]
    
    var body: some View {
        Form {
            Section(header: Text("Layout & Design")) {
                Picker("Keyboard Layout", selection: $settings.keyboardLayout) {
                    ForEach(layouts, id: \.self) { layout in
                        Text(layout).tag(layout)
                    }
                }
                .pickerStyle(.segmented)
                
                Toggle("Premium Dark Mode", isOn: $settings.isDarkMode)
            }
            
            Section(header: Text("Typing Assistance")) {
                Toggle("Autocorrect", isOn: $settings.autocorrect)
                Toggle("Suggestions Bar", isOn: .constant(true)) // Always active in FUTO
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Spacebar Glide Cursor Sensitivity")
                        Spacer()
                        Text(String(format: "%.0f%%", settings.swipeSensitivity * 100))
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $settings.swipeSensitivity, in: 0.1...1.0)
                }
            }
            
            Section(header: Text("Feedback & Interaction"), footer: Text("Haptic vibration requires 'Allow Full Access' in iOS settings.")) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Haptic Feedback Strength")
                        Spacer()
                        Text(settings.hapticFeedbackStrength == 0 ? "Disabled" : String(format: "%.0f%%", settings.hapticFeedbackStrength * 100))
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $settings.hapticFeedbackStrength, in: 0.0...1.0)
                }
                
                Toggle("Keypress Sound Effects", isOn: $settings.keypressSounds)
            }
            
            Section(header: Text("Privacy & Offline Mode")) {
                HStack {
                    Image(systemName: "checkmark.shield.fill")
                        .foregroundColor(.green)
                    Text("100% Offline and Private")
                        .bold()
                }
                Text("FUTO Keyboard has zero internet capabilities, protecting your typing data, logins, and passwords from leaking to external cloud servers.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("FUTO Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}
