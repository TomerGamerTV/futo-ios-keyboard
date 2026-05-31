import SwiftUI

struct AboutView: View {
    @EnvironmentObject var settings: KeyboardSettings
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with FUTO branding logo mock
                VStack(spacing: 8) {
                    Image(systemName: "keyboard.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(LinearGradient(colors: [.cyan, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
                        .padding(.top, 24)
                    
                    Text("FUTO Keyboard for iOS")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(settings.isDarkMode ? .white : .black)
                    
                    Text("Version 1.0.0 Stable")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Digital Sovereignty")
                        .font(.headline)
                        .foregroundColor(settings.isDarkMode ? .white : .black)
                    
                    Text("FUTO is an organization dedicated to developing alternative technology infrastructure that returns control of digital devices to the people who buy them. Our products, like the FUTO Keyboard, are built to protect your fundamental right to privacy.")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Text("FUTO Source First License 1.1")
                        .font(.headline)
                        .foregroundColor(settings.isDarkMode ? .white : .black)
                    
                    Text("This application's source code is hosted publicly and is licensed under the FUTO Source First License. It ensures that the software remains transparent, reviewable, and run by you, without spy capabilities or background telemetry tracking.")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Text("Developer Contributions & CLA")
                        .font(.headline)
                        .foregroundColor(settings.isDarkMode ? .white : .black)
                    
                    Text("Our main keyboard layouts are completely open-source under Apache-2.0, meaning any developer can contribute keyboards and layouts freely. Pull requests to the core engine are welcome and require signing our Contributor License Agreement (CLA) to ensure clean licensing.")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(settings.isDarkMode ? Color.white.opacity(0.04) : Color.black.opacity(0.02))
                .cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.08), lineWidth: 1))
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle("About FUTO")
        .navigationBarTitleDisplayMode(.inline)
    }
}
