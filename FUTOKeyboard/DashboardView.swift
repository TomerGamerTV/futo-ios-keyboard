import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var settings: KeyboardSettings
    @State private var animateBackground = false
    @State private var activeTab = 0
    @State private var showingKeyboardSetup = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Vibrant dynamic background
                LinearGradient(colors: settings.isDarkMode ? 
                               [.black, Color(red: 0.05, green: 0.05, blue: 0.15), Color(red: 0.1, green: 0.05, blue: 0.2)] : 
                               [Color.white, Color(red: 0.95, green: 0.95, blue: 1.0), Color(red: 0.9, green: 0.9, blue: 0.98)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                // Animated floating blobs for high premium aesthetics
                Circle()
                    .fill(LinearGradient(colors: [Color.purple.opacity(settings.isDarkMode ? 0.3 : 0.15), Color.blue.opacity(settings.isDarkMode ? 0.2 : 0.1)], startPoint: .top, endPoint: .bottom))
                    .frame(width: 350, height: 350)
                    .blur(radius: 60)
                    .offset(x: animateBackground ? 100 : -100, y: animateBackground ? -150 : -50)
                
                Circle()
                    .fill(LinearGradient(colors: [Color.cyan.opacity(settings.isDarkMode ? 0.25 : 0.1), Color.purple.opacity(settings.isDarkMode ? 0.2 : 0.1)], startPoint: .top, endPoint: .bottom))
                    .frame(width: 300, height: 300)
                    .blur(radius: 50)
                    .offset(x: animateBackground ? -120 : 120, y: animateBackground ? 200 : 100)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Title header
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("FUTO KEYBOARD")
                                    .font(.system(.title2, design: .monospaced))
                                    .fontWeight(.bold)
                                    .foregroundStyle(LinearGradient(colors: [.cyan, .purple], startPoint: .leading, endPoint: .trailing))
                                Text("Privacy-first typing engine")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            
                            // 100% Offline Badge
                            HStack(spacing: 6) {
                                Image(systemName: "shield.fill")
                                    .foregroundColor(.green)
                                Text("100% Offline")
                                    .font(.caption2)
                                    .bold()
                                    .foregroundColor(.green)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.green.opacity(0.15))
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.green.opacity(0.3), lineWidth: 1))
                        }
                        .padding(.top, 16)
                        
                        // Setup status widget
                        StatusWidget(showingSetup: $showingKeyboardSetup)
                        
                        // Interactive mini keyboard preview widget
                        KeyboardPreviewWidget()
                            .padding(.horizontal, 4)
                        
                        // Feature Modules Grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            NavigationLink(destination: OnboardingView()) {
                                FeatureCard(title: "Setup Guide", subtitle: "Enable & Activate", icon: "keyboard", color: .blue)
                            }
                            
                            NavigationLink(destination: ThemesView()) {
                                FeatureCard(title: "Themes", subtitle: "Colors & Styles", icon: "paintpalette", color: .purple)
                            }
                            
                            NavigationLink(destination: SettingsView()) {
                                FeatureCard(title: "Settings", subtitle: "Preferences", icon: "gearshape", color: .cyan)
                            }
                            
                            NavigationLink(destination: DictationView()) {
                                FeatureCard(title: "Voice Typing", subtitle: "Offline Whisper", icon: "mic", color: .orange)
                            }
                        }
                        
                        // About Section Card
                        NavigationLink(destination: AboutView()) {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.purple)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Digital Sovereignty & CLA")
                                        .font(.headline)
                                        .foregroundColor(settings.isDarkMode ? .white : .black)
                                    Text("Learn about FUTO license and code hosting")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(settings.isDarkMode ? Color.white.opacity(0.06) : Color.black.opacity(0.03))
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 1))
                        }
                        
                        // Keystrokes privacy counter
                        VStack(spacing: 8) {
                            Text("12,481")
                                .font(.system(.largeTitle, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            Text("Keystrokes Kept 100% Private Locally")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(settings.isDarkMode ? Color.white.opacity(0.04) : Color.black.opacity(0.02))
                        .cornerRadius(16)
                        .padding(.bottom, 24)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("FUTO Dashboard")
            .navigationBarHidden(true)
            .sheet(isPresented: $showingKeyboardSetup) {
                OnboardingView()
            }
            .onAppear {
                withAnimation(.linear(duration: 12).repeatForever(autoreverses: true)) {
                    animateBackground.toggle()
                }
            }
        }
    }
}

struct StatusWidget: View {
    @EnvironmentObject var settings: KeyboardSettings
    @Binding var showingSetup: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.orange.opacity(0.2))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Needs Activation")
                    .font(.headline)
                    .foregroundColor(settings.isDarkMode ? .white : .black)
                Text("Complete steps to enable FUTO system-wide")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            
            Button("Activate") {
                showingSetup = true
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
            .foregroundColor(.white)
            .bold()
            .cornerRadius(12)
        }
        .padding()
        .background(settings.isDarkMode ? Color.white.opacity(0.06) : Color.black.opacity(0.03))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
}

struct KeyboardPreviewWidget: View {
    @EnvironmentObject var settings: KeyboardSettings
    
    var themeColor: Color {
        switch settings.activeTheme {
        case "Neon Aurora": return .cyan
        case "FUTO Classic Dark": return .purple
        case "Obsidian Glass": return .orange
        default: return .blue
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            headerRow
            
            VStack(spacing: 6) {
                suggestionBarMockup
                keyRowsMockup
                spacebarRowMockup
            }
            .padding(10)
            .background(settings.isDarkMode ? Color.black.opacity(0.4) : Color.white.opacity(0.8))
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
            .shadow(color: themeColor.opacity(0.15), radius: 8, x: 0, y: 4)
        }
        .padding()
        .background(settings.isDarkMode ? Color.white.opacity(0.04) : Color.black.opacity(0.02))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.06), lineWidth: 1))
    }
    
    private var headerRow: some View {
        HStack {
            Text("Theme Preview:")
                .font(.caption)
                .foregroundColor(.secondary)
            Text(settings.activeTheme)
                .font(.caption)
                .bold()
                .foregroundColor(themeColor)
            Spacer()
            Text(settings.keyboardLayout)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(Color.white.opacity(0.1))
                .cornerRadius(4)
        }
    }
    
    private var suggestionBarMockup: some View {
        HStack(spacing: 12) {
            Text("FUTO")
                .font(.caption2)
                .bold()
                .foregroundColor(themeColor)
            Divider().frame(height: 12)
            Text("Keyboard")
                .font(.caption2)
                .foregroundColor(.secondary)
            Divider().frame(height: 12)
            Text("Privacy")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 28)
        .background(Color.white.opacity(0.05))
        .cornerRadius(6)
    }
    
    private var keyRowsMockup: some View {
        VStack(spacing: 6) {
            ForEach(0..<3) { rowIndex in
                HStack(spacing: 5) {
                    if rowIndex == 2 {
                        Image(systemName: "shift")
                            .font(.caption2)
                            .frame(width: 28, height: 28)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    let keyCount = rowIndex == 0 ? 10 : (rowIndex == 1 ? 9 : 7)
                    ForEach(0..<keyCount, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.15))
                            .frame(height: 28)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(themeColor.opacity(0.3), lineWidth: 0.5)
                            )
                    }
                    
                    if rowIndex == 2 {
                        Image(systemName: "delete.left")
                            .font(.caption2)
                            .frame(width: 28, height: 28)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
            }
        }
    }
    
    private var spacebarRowMockup: some View {
        HStack(spacing: 6) {
            Text("123")
                .font(.system(size: 8))
                .frame(width: 32, height: 28)
                .background(Color.white.opacity(0.1))
                .cornerRadius(4)
            
            Image(systemName: "mic.fill")
                .font(.system(size: 8))
                .frame(width: 28, height: 28)
                .background(Color.white.opacity(0.1))
                .cornerRadius(4)
            
            Text("swipe for cursor")
                .font(.system(size: 8))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity)
                .frame(height: 28)
                .background(Color.white.opacity(0.2))
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(themeColor.opacity(0.5), lineWidth: 1)
                )
            
            Text("Go")
                .font(.system(size: 8))
                .bold()
                .frame(width: 40, height: 28)
                .background(themeColor.opacity(0.4))
                .cornerRadius(4)
        }
    }
}

struct FeatureCard: View {
    @EnvironmentObject var settings: KeyboardSettings
    var title: String
    var subtitle: String
    var icon: String
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Circle()
                .fill(color.opacity(settings.isDarkMode ? 0.15 : 0.08))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.title3)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(settings.isDarkMode ? .white : .black)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(settings.isDarkMode ? Color.white.opacity(0.05) : Color.black.opacity(0.03))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.08), lineWidth: 1))
    }
}
