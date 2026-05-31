import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var settings: KeyboardSettings
    @State private var currentStep = 0
    
    var body: some View {
        ZStack {
            LinearGradient(colors: settings.isDarkMode ? 
                           [.black, Color(red: 0.05, green: 0.05, blue: 0.15)] : 
                           [.white, Color(red: 0.95, green: 0.95, blue: 1.0)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                            .padding(8)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Text("Keyboard Setup")
                        .font(.headline)
                    Spacer()
                    // Empty placeholder to center title
                    Color.clear.frame(width: 32, height: 32)
                }
                .padding(.horizontal)
                .padding(.top, 16)
                
                // Steps indicator
                HStack(spacing: 8) {
                    ForEach(0..<4) { index in
                        Capsule()
                            .fill(index == currentStep ? Color.cyan : Color.secondary.opacity(0.3))
                            .frame(width: index == currentStep ? 24 : 8, height: 8)
                            .animation(.spring(), value: currentStep)
                    }
                }
                
                // Interactive walkthrough slides
                TabView(selection: $currentStep) {
                    StepView(
                        image: "gearshape.2.fill",
                        title: "1. Open iOS Settings",
                        description: "Go to your iPhone's system settings. You can do this quickly by tapping the button below.",
                        color: .blue
                    ).tag(0)
                    
                    StepView(
                        image: "keyboard.fill",
                        title: "2. Keyboard Options",
                        description: "Navigate to General, then Keyboard, and select the 'Keyboards' menu item at the top of the screen.",
                        color: .purple
                    ).tag(1)
                    
                    StepView(
                        image: "plus.circle.fill",
                        title: "3. Add FUTO Keyboard",
                        description: "Tap 'Add New Keyboard...' and select 'FUTO Keyboard' from the list of Third-Party Keyboards.",
                        color: .cyan
                    ).tag(2)
                    
                    StepView(
                        image: "lock.open.fill",
                        title: "4. Enable Full Access",
                        description: "Select 'FUTO Keyboard' from your keyboards list, and toggle 'Allow Full Access' to enable haptic typing and speech dictation.",
                        color: .orange
                    ).tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Action Buttons
                VStack(spacing: 12) {
                    if currentStep < 3 {
                        Button(action: {
                            withAnimation { currentStep += 1 }
                        }) {
                            Text("Next Step")
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(LinearGradient(colors: [.cyan, .blue], startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .bold()
                                .cornerRadius(16)
                        }
                    } else {
                        Button(action: {
                            // Deep link to iPhone system settings
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Go to System Settings")
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(LinearGradient(colors: [.orange, .red], startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .bold()
                                .cornerRadius(16)
                        }
                    }
                    
                    Button(action: { dismiss() }) {
                        Text("Maybe Later")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }
}

struct StepView: View {
    var image: String
    var title: String
    var description: String
    var color: Color
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 140, height: 140)
                
                Image(systemName: image)
                    .font(.system(size: 64))
                    .foregroundColor(color)
                    .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.top, 20)
            
            VStack(spacing: 12) {
                Text(title)
                    .font(.title2)
                    .bold()
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            Spacer()
        }
    }
}
