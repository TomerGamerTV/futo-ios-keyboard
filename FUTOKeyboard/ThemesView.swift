import SwiftUI

struct ThemesView: View {
    @EnvironmentObject var settings: KeyboardSettings
    
    let themes = [
        ThemeOption(name: "Neon Aurora", colors: [.cyan, .purple], isDark: true, desc: "Cyberpunk neon cyan and purple glows"),
        ThemeOption(name: "FUTO Classic Dark", colors: [.purple, Color(red: 0.1, green: 0.05, blue: 0.2)], isDark: true, desc: "Classic offline deep purple design"),
        ThemeOption(name: "Obsidian Glass", colors: [.orange, .black], isDark: true, desc: "Glowing translucent amber on deep obsidian"),
        ThemeOption(name: "Paper White", colors: [.blue, .white], isDark: false, desc: "Clean, high-contrast, professional day theme")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Interactive theme configurator widget
                KeyboardPreviewWidget()
                    .padding()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Active Theme")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(themes, id: \.name) { theme in
                        HStack(spacing: 16) {
                            // Circular color gradient indicator
                            Circle()
                                .fill(LinearGradient(colors: theme.colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(theme.name)
                                    .font(.headline)
                                    .foregroundColor(settings.isDarkMode ? .white : .black)
                                Text(theme.desc)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            
                            if settings.activeTheme == theme.name {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(theme.colors.first)
                            }
                        }
                        .padding()
                        .background(settings.isDarkMode ? Color.white.opacity(0.05) : Color.black.opacity(0.02))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(settings.activeTheme == theme.name ? theme.colors.first!.opacity(0.5) : Color.clear, lineWidth: 1.5)
                        )
                        .onTapGesture {
                            withAnimation {
                                settings.activeTheme = theme.name
                                settings.isDarkMode = theme.isDark
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationTitle("Keyboard Themes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ThemeOption {
    var name: String
    var colors: [Color]
    var isDark: Bool
    var desc: String
}
