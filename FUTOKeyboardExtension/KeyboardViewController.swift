import UIKit
import SwiftUI
import AudioToolbox

class KeyboardViewController: UIInputViewController {
    private var hostingController: UIHostingController<KeyboardView>?
    private var state = KeyboardState()
    private var suggestionEngine = SuggestionEngine()
    
    // Tracking composing text state
    private var composingWord = ""
    
    // Track cursor glide drag history
    private var lastGlideOffset: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Load active settings from shared App Group defaults
        loadSharedPreferences()
        
        // 2. Set up SwiftUI view in hosting controller
        let keyboardView = KeyboardView(
            state: state,
            onKeyPress: { [weak self] key in
                self?.handleKeyPress(key)
            },
            onDelete: { [weak self] in
                self?.handleDelete()
            },
            onSpaceGlide: { [weak self] delta in
                self?.handleSpacebarGlide(delta: delta)
            },
            onSuggestionTap: { [weak self] word in
                self?.handleSuggestionTap(word)
            }
        )
        
        let host = UIHostingController(rootView: keyboardView)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.backgroundColor = .clear
        
        addChild(host)
        view.addSubview(host.view)
        host.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            host.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            host.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        self.hostingController = host
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // Prepare for input context change
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // Read active text proxy and extract current composing prefix
        updateSuggestions()
    }
    
    private func loadSharedPreferences() {
        let defaults = UserDefaults(suiteName: "group.org.futo.keyboard")
        
        let systemIsDark = self.traitCollection.userInterfaceStyle == .dark
        
        if defaults?.object(forKey: "isDarkMode") == nil {
            state.isDarkMode = systemIsDark
        } else {
            state.isDarkMode = defaults?.bool(forKey: "isDarkMode") ?? systemIsDark
        }
        
        state.keyboardLayout = defaults?.string(forKey: "keyboardLayout") ?? "QWERTY"
        state.activeTheme = defaults?.string(forKey: "activeTheme") ?? "Neon Aurora"
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        loadSharedPreferences()
    }
    
    private func handleKeyPress(_ text: String) {
        // Play system standard keypress audio feedback
        let defaults = UserDefaults(suiteName: "group.org.futo.keyboard")
        let soundsEnabled = defaults?.bool(forKey: "keypressSounds") ?? true
        if soundsEnabled {
            UIDevice.current.playInputClick()
        }
        
        // Generate light mechanical haptic ticks on tap
        let hapticStrength = defaults?.double(forKey: "hapticFeedback") ?? 0.5
        if hapticStrength > 0 {
            let generator = UIImpactFeedbackGenerator(style: hapticStrength > 0.6 ? .medium : .light)
            generator.prepare()
            generator.impactOccurred()
        }
        
        if text == "\n" {
            // Newline / Return
            textDocumentProxy.insertText("\n")
            composingWord = ""
        } else {
            textDocumentProxy.insertText(text)
            composingWord.append(text)
        }
        
        updateSuggestions()
    }
    
    private func handleDelete() {
        let defaults = UserDefaults(suiteName: "group.org.futo.keyboard")
        let soundsEnabled = defaults?.bool(forKey: "keypressSounds") ?? true
        if soundsEnabled {
            UIDevice.current.playInputClick()
        }
        
        textDocumentProxy.deleteBackward()
        if !composingWord.isEmpty {
            composingWord.removeLast()
        }
        
        updateSuggestions()
    }
    
    // Horizontal swipe on spacebar tracks offset to shift cursor character-by-character
    private func handleSpacebarGlide(delta: CGFloat) {
        let threshold: CGFloat = 20.0
        let sensitivity = UserDefaults(suiteName: "group.org.futo.keyboard")?.double(forKey: "swipeSensitivity") ?? 0.5
        
        let adjustedThreshold = threshold * (1.1 - sensitivity) // higher sensitivity = smaller movement needed
        let difference = delta - lastGlideOffset
        
        if abs(difference) > adjustedThreshold {
            let offset = difference > 0 ? 1 : -1
            textDocumentProxy.adjustTextPosition(byCharacterOffset: offset)
            
            // Light haptic tick for each character shifted
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
            
            lastGlideOffset = delta
        }
        
        // Reset anchor on release / gesture end
        if delta == 0 {
            lastGlideOffset = 0
        }
    }
    
    private func handleSuggestionTap(_ suggestion: String) {
        // Replace current composing word with suggestion
        for _ in 0..<composingWord.count {
            textDocumentProxy.deleteBackward()
        }
        
        textDocumentProxy.insertText(suggestion + " ")
        
        // Learn typed word to adapt offline intelligence locally
        suggestionEngine.learnWord(suggestion)
        
        composingWord = ""
        updateSuggestions()
    }
    
    private func updateSuggestions() {
        if composingWord.isEmpty {
            state.suggestions = []
        } else {
            state.suggestions = suggestionEngine.getSuggestions(for: composingWord)
        }
    }
}
