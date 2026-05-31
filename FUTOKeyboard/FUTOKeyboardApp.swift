import SwiftUI

@main
struct FUTOKeyboardApp: App {
    @StateObject private var settings = KeyboardSettings()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environmentObject(settings)
                .preferredColorScheme(settings.isDarkMode ? .dark : .light)
        }
    }
}

class KeyboardSettings: ObservableObject {
    @AppStorage("isDarkMode", store: UserDefaults(suiteName: "group.org.futo.keyboard"))
    var isDarkMode: Bool = true
    
    @AppStorage("keyboardLayout", store: UserDefaults(suiteName: "group.org.futo.keyboard"))
    var keyboardLayout: String = "QWERTY"
    
    @AppStorage("hapticFeedback", store: UserDefaults(suiteName: "group.org.futo.keyboard"))
    var hapticFeedbackStrength: Double = 0.5 // 0.0 to 1.0 (0 = disabled)
    
    @AppStorage("keypressSounds", store: UserDefaults(suiteName: "group.org.futo.keyboard"))
    var keypressSounds: Bool = true
    
    @AppStorage("autocorrect", store: UserDefaults(suiteName: "group.org.futo.keyboard"))
    var autocorrect: Bool = true
    
    @AppStorage("activeTheme", store: UserDefaults(suiteName: "group.org.futo.keyboard"))
    var activeTheme: String = "Neon Aurora"
    
    @AppStorage("swipeSensitivity", store: UserDefaults(suiteName: "group.org.futo.keyboard"))
    var swipeSensitivity: Double = 0.5
}
