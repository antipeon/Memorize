//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Samat Gaynutdinov on 03.07.2022.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    private var themeChooser = ThemeChooser()
    
    @Published private var theme: ThemeChooser.Theme!
    
    @Published private var model: MemoryGame<String>!
    
    init() {
        startNewGame()
    }
    
    private func createTheme() -> ThemeChooser.Theme {
        ThemeChooser().getTheme()
    }
    
    private func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairs) { cardIndex in
            theme.emojis[cardIndex]
        }
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    var foregroundColor: ThemeChooser.Theme.Color {
        theme.color
    }
    
    var themeName: String {
        theme.title
    }
    
    var score: String {
        String(model.scoreTracker.score)
    }
    
    // MARK: - Intent(s)
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func startNewGame() {
        theme = themeChooser.getTheme()
        model = createMemoryGame()
    }
}
