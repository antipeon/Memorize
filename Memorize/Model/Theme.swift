//
//  Theme.swift
//  Memorize
//
//  Created by Samat Gaynutdinov on 03.07.2022.
//

import Foundation

struct ThemeChooser {
    struct Theme {
        var emojis: [String]
        var title: String
        var numberOfPairs: Int
        var color: Color
        
        enum Color {
            case red
            case blue
            case orange
        }
    }
    
    init() {
        addThemeWithComponents(emojis: ThemeChooser.emojis.first!, title: "faces", numberOfPairs: 4, color: Theme.Color.red)
        addThemeWithComponents(emojis: ThemeChooser.emojis[1], title: "spooky", numberOfPairs: 5, color: Theme.Color.orange)
        addThemeWithComponents(emojis: ThemeChooser.emojis.last!, title: "love", numberOfPairs: 3, color: Theme.Color.blue)
    }
    
    private static var emojis: [Set<String>] = [
        ["😀", "😍", "😇", "🤪", "😎", "😡", "😤", "😈", "🤢", "🥶" ,"🤡"],
        ["🎃", "👻", "😈", "🍭", "🦇", "🔪", "👹", "💀", "👁", "🦾"],
        ["❤️", "💔", "💜", "💖", "💗", "💓", "😻", "👀", "👚", "👨‍👩‍👦‍👦"]
    ]
    
    private var themes = [Theme]()
    
    mutating func addThemeWithComponents(emojis: Set<String>, title: String, numberOfPairs: Int, color: Theme.Color) {
        let emojisCount = min(emojis.count, numberOfPairs)
        var indices = emojis.indices.shuffled()
        indices.removeLast(indices.count - emojisCount)
        themes.append(Theme(emojis: indices.map { emojis[$0] }, title: title, numberOfPairs: emojisCount, color: color))
    }
    
    func getTheme() -> Theme {
        return themes[themes.count.random()]
    }
}
