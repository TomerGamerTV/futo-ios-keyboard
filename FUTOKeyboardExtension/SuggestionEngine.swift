import Foundation

class SuggestionEngine {
    private var commonWords = [
        "the", "be", "to", "of", "and", "a", "in", "that", "have", "i",
        "it", "for", "not", "on", "with", "he", "as", "you", "do", "at",
        "this", "but", "his", "by", "from", "they", "we", "say", "her", "she",
        "or", "an", "will", "my", "one", "all", "would", "there", "their", "what",
        "so", "up", "out", "if", "about", "who", "get", "which", "go", "me",
        "when", "make", "can", "like", "time", "no", "just", "him", "know", "take",
        "people", "into", "year", "your", "good", "some", "could", "them", "see", "other",
        "than", "then", "now", "look", "only", "come", "its", "over", "think", "also",
        "back", "after", "use", "two", "how", "our", "work", "first", "well", "way",
        "even", "new", "want", "because", "any", "these", "give", "day", "most", "us",
        "futo", "keyboard", "private", "offline", "secure", "sovereign", "technology"
    ]
    
    // User adaptive vocabulary dictionary
    private var userWords: [String: Int] = [:]
    
    func getSuggestions(for prefix: String) -> [String] {
        let cleanPrefix = prefix.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanPrefix.isEmpty else { return [] }
        
        // 1. Gather all candidates matching the prefix
        var candidates = commonWords.filter { $0.hasPrefix(cleanPrefix) }
        
        // 2. Add user-specific custom matching words
        let userMatches = userWords.keys.filter { $0.hasPrefix(cleanPrefix) }
        candidates.append(contentsOf: userMatches)
        
        // 3. De-duplicate candidates
        var uniqueCandidates = Array(Set(candidates))
        
        // 4. Sort: Prioritize user words first, then sort by length
        uniqueCandidates.sort { (a, b) -> Bool in
            let aFreq = userWords[a] ?? 0
            let bFreq = userWords[b] ?? 0
            if aFreq != bFreq {
                return aFreq > bFreq
            }
            return a.count < b.count
        }
        
        // 5. Return top 3 candidates
        return Array(uniqueCandidates.prefix(3))
    }
    
    func learnWord(_ word: String) {
        let cleanWord = word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard cleanWord.count > 1 else { return }
        
        userWords[cleanWord, default: 0] += 1
    }
}
