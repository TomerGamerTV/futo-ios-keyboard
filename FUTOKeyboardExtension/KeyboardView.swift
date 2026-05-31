import SwiftUI

struct KeyboardView: View {
    @ObservedObject var state: KeyboardState
    var onKeyPress: (String) -> Void
    var onDelete: () -> Void
    var onSpaceGlide: (CGFloat) -> Void
    var onSuggestionTap: (String) -> Void
    
    @State private var showingEmoji = false
    @State private var showingSymbols = false
    @State private var isShifted = false
    @State private var selectedAltKeys: [String] = []
    @State private var longPressKey: String? = nil
    
    // Drag tracking for spacebar glide cursor control
    @GestureState private var dragOffset: CGFloat = 0.0
    
    var themeColor: Color {
        switch state.activeTheme {
        case "Neon Aurora": return .cyan
        case "FUTO Classic Dark": return .purple
        case "Obsidian Glass": return .orange
        default: return .blue
        }
    }
    
    var backgroundColor: Color {
        if state.isDarkMode {
            return Color(red: 0.08, green: 0.08, blue: 0.12)
        } else {
            return Color(red: 0.94, green: 0.94, blue: 0.96)
        }
    }
    
    var keyColor: Color {
        if state.isDarkMode {
            return Color.white.opacity(0.12)
        } else {
            return Color.white
        }
    }
    
    var keyTextColor: Color {
        state.isDarkMode ? .white : .black
    }
    
    var body: some View {
        VStack(spacing: 6) {
            // Smart Suggestions / Predictive Text Bar
            HStack {
                if state.suggestions.isEmpty {
                    Spacer()
                    Image(systemName: "checkmark.shield.fill")
                        .foregroundColor(.green.opacity(0.7))
                        .font(.caption2)
                    Text("FUTO Offline Protection Active")
                        .font(.caption2)
                        .foregroundColor(state.isDarkMode ? Color.white.opacity(0.6) : Color.black.opacity(0.6))
                    Spacer()
                } else {
                    ForEach(state.suggestions, id: \.self) { suggestion in
                        Button(action: { onSuggestionTap(suggestion) }) {
                            Text(suggestion)
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(themeColor)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.white.opacity(state.isDarkMode ? 0.08 : 0.4))
                                .cornerRadius(8)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .frame(height: 38)
            .background(backgroundColor.opacity(0.8))
            .cornerRadius(10)
            .padding(.horizontal, 4)
            .padding(.top, 4)
            
            if showingEmoji {
                // Emoji Panel Grid
                EmojiPanel(onEmojiSelect: { onKeyPress($0) }, onClose: { showingEmoji = false }, state: state)
            } else {
                // Standard Alphabet Keyboard Grid
                VStack(spacing: 8) {
                    let layout = showingSymbols ? KeyboardLayouts.symbols : 
                        (state.keyboardLayout == "QWERTZ" ? KeyboardLayouts.qwertz : 
                         (state.keyboardLayout == "AZERTY" ? KeyboardLayouts.azerty : KeyboardLayouts.qwerty))
                    
                    ForEach(0..<layout.count, id: \.self) { rowIndex in
                        HStack(spacing: 6) {
                            // Extra keys on row 3 (Shift / Symbols toggle)
                            if rowIndex == 2 {
                                Button(action: {
                                    if showingSymbols {
                                        showingSymbols = false
                                    } else {
                                        isShifted.toggle()
                                    }
                                }) {
                                    Image(systemName: showingSymbols ? "abc" : (isShifted ? "shift.fill" : "shift"))
                                        .font(.headline)
                                        .frame(width: 44, height: 42)
                                        .background(keyColor.opacity(0.8))
                                        .foregroundColor(keyTextColor)
                                        .cornerRadius(6)
                                }
                            }
                            
                            ForEach(layout[rowIndex], id: \.self) { key in
                                let keyLabel = isShifted ? key.uppercased() : key
                                
                                Button(action: {
                                    onKeyPress(keyLabel)
                                    if isShifted { isShifted = false } // Reset shift on tap
                                }) {
                                    Text(keyLabel)
                                        .font(.title3)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 42)
                                        .background(keyColor)
                                        .foregroundColor(keyTextColor)
                                        .cornerRadius(6)
                                        .shadow(color: Color.black.opacity(state.isDarkMode ? 0.3 : 0.1), radius: 1, x: 0, y: 1)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(longPressKey == key ? themeColor : Color.clear, lineWidth: 1.5)
                                        )
                                }
                                .simultaneousGesture(
                                    LongPressGesture(minimumDuration: 0.4).onEnded { _ in
                                        if let alternates = KeyboardLayouts.keyAlternates[key] {
                                            selectedAltKeys = alternates
                                            longPressKey = key
                                        }
                                    }
                                )
                            }
                            
                            // Delete backspace key on row 3
                            if rowIndex == 2 {
                                Button(action: onDelete) {
                                    Image(systemName: "delete.left")
                                        .font(.headline)
                                        .frame(width: 44, height: 42)
                                        .background(keyColor.opacity(0.8))
                                        .foregroundColor(keyTextColor)
                                        .cornerRadius(6)
                                }
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                    
                    // Spacebar and special actions bottom row
                    HStack(spacing: 6) {
                        // Symbols toggle
                        Button(action: { showingSymbols.toggle() }) {
                            Text(showingSymbols ? "ABC" : "123")
                                .font(.subheadline)
                                .bold()
                                .frame(width: 46, height: 42)
                                .background(keyColor.opacity(0.8))
                                .foregroundColor(keyTextColor)
                                .cornerRadius(6)
                        }
                        
                        // Emoji trigger
                        Button(action: { showingEmoji = true }) {
                            Image(systemName: "face.smiling")
                                .font(.headline)
                                .frame(width: 42, height: 42)
                                .background(keyColor.opacity(0.8))
                                .foregroundColor(keyTextColor)
                                .cornerRadius(6)
                        }
                        
                        // Haptic Glide Cursor Spacebar
                        Button(action: {
                            onKeyPress(" ")
                        }) {
                            Text(state.isDictating ? "transcribing locally..." : "FUTO SPACE")
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(state.isDictating ? themeColor : keyTextColor.opacity(0.6))
                                .frame(maxWidth: .infinity)
                                .frame(height: 42)
                                .background(state.isDictating ? themeColor.opacity(0.15) : keyColor)
                                .cornerRadius(6)
                                .shadow(color: Color.black.opacity(state.isDarkMode ? 0.3 : 0.1), radius: 1, x: 0, y: 1)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(themeColor.opacity(0.4), lineWidth: 1.5)
                                )
                        }
                        .buttonStyle(.plain)
                        .gesture(
                            DragGesture()
                                .updating($dragOffset) { value, drag, _ in
                                    drag = value.translation.width
                                }
                                .onChanged { value in
                                    onSpaceGlide(value.translation.width)
                                }
                        )
                        
                        // Mic Button (Offline transcription simulate)
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                state.isDictating.toggle()
                            }
                        }) {
                            Image(systemName: state.isDictating ? "mic.fill" : "mic")
                                .font(.headline)
                                .frame(width: 42, height: 42)
                                .background(state.isDictating ? themeColor.opacity(0.3) : keyColor.opacity(0.8))
                                .foregroundColor(state.isDictating ? themeColor : keyTextColor)
                                .cornerRadius(6)
                                .overlay(
                                    Circle()
                                        .stroke(themeColor, lineWidth: state.isDictating ? 1.5 : 0)
                                        .scaleEffect(state.isDictating ? 1.4 : 1.0)
                                        .opacity(state.isDictating ? 0 : 1)
                                        .animation(state.isDictating ? .easeOut(duration: 1.0).repeatForever(autoreverses: false) : .default, value: state.isDictating)
                                )
                        }
                        
                        // Return key
                        Button(action: { onKeyPress("\n") }) {
                            Text("Go")
                                .font(.subheadline)
                                .bold()
                                .frame(width: 56, height: 42)
                                .background(themeColor.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(6)
                        }
                    }
                    .padding(.horizontal, 4)
                    .padding(.bottom, 8)
                }
            }
            
            // Accents / Alternates overlay popups panel
            if !selectedAltKeys.isEmpty {
                HStack(spacing: 8) {
                    Text("Alternates:")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    ForEach(selectedAltKeys, id: \.self) { altKey in
                        Button(action: {
                            onKeyPress(altKey)
                            selectedAltKeys = []
                            longPressKey = nil
                        }) {
                            Text(altKey)
                                .font(.headline)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(themeColor.opacity(0.2))
                                .foregroundColor(keyTextColor)
                                .cornerRadius(4)
                        }
                    }
                    Spacer()
                    Button(action: {
                        selectedAltKeys = []
                        longPressKey = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(backgroundColor)
                .cornerRadius(8)
            }
        }
        .background(backgroundColor)
        .ignoresSafeArea()
    }
}

// Emoji Keyboard Component
struct EmojiPanel: View {
    var onEmojiSelect: (String) -> Void
    var onClose: () -> Void
    var state: KeyboardState
    
    let emojis = [
        "😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣", "😊", "😇",
        "🙂", "🙃", "😉", "😌", "😍", "🥰", "😘", "😗", "😙", "😚",
        "😋", "😛", "😝", "😜", "🤪", "🤨", "🧐", "🤓", "😎", "🤩",
        "🥳", "😏", "😒", "😞", "😔", "😟", "😕", "🙁", "☹️", "😣",
        "❤️", "🧡", "💛", "💚", "💙", "💜", "🖤", "🤍", "🤎", "💖",
        "👍", "👎", "👊", "✊", "🤛", "🤜", "🤞", "✌️", "🤟", "🤘"
    ]
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text("Frequently Used Emojis")
                    .font(.caption)
                    .foregroundColor(state.isDarkMode ? Color.white.opacity(0.6) : Color.black.opacity(0.6))
                    .bold()
                Spacer()
                Button(action: onClose) {
                    Text("ABC")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.12))
                        .foregroundColor(state.isDarkMode ? .white : .black)
                        .cornerRadius(6)
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.fixed(38)), GridItem(.fixed(38))], spacing: 10) {
                    ForEach(emojis, id: \.self) { emoji in
                        Button(action: { onEmojiSelect(emoji) }) {
                            Text(emoji)
                                .font(.title)
                                .frame(width: 44, height: 44)
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
            .frame(height: 120)
        }
        .background(state.isDarkMode ? Color.black.opacity(0.3) : Color.white.opacity(0.6))
        .cornerRadius(10)
        .padding(.horizontal, 4)
    }
}

class KeyboardState: ObservableObject {
    @Published var isDarkMode: Bool = true
    @Published var keyboardLayout: String = "QWERTY"
    @Published var suggestions: [String] = []
    @Published var isDictating: Bool = false
    @Published var activeTheme: String = "Neon Aurora"
}
