//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Samat Gaynutdinov on 03.07.2022.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    private static var theme = ThemeChooser.getTheme(theme: .love)
    
    @Published var memoryGame = createMemoryGame()
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4) { cardIndex in
            theme.emojis[cardIndex]
        }
    }
}

struct ThemeChooser {
    struct Theme {
        var emojis: [String]
        var title: String
        var label: Image
        var themeTitle: ThemeTitle
    }
    
    private static var emojis = [
        ["😀", "😍", "😇", "🤪", "😎", "😡", "😤", "😈", "🤢", "🥶" ,"🤡"],
        ["🎃", "👻", "😈", "🍭", "🦇", "🔪", "👹", "💀", "👁", "🦾"],
        ["❤️", "💔", "💜", "💖", "💗", "💓", "😻", "👀", "👚", "👨‍👩‍👦‍👦"]
    ]
    enum ThemeTitle: Int {
        case faces = 0
        case corona
        case love
    }
    
    static func getTheme(theme: ThemeTitle) -> Theme {
        let emojis = emojis[theme.rawValue].shuffled()
        switch theme {
        case .faces:
            return Theme(emojis: emojis, title: "faces", label: Image(systemName: "face.smiling"), themeTitle: theme)
        case .love:
            return Theme(emojis: emojis, title: "love", label: Image(systemName: "heart"), themeTitle: theme)
        case .corona:
            return Theme(emojis: emojis, title: "corona", label: Image(systemName: "facemask"), themeTitle: theme)
        }
    }
}
