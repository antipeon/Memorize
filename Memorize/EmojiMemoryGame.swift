//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Samat Gaynutdinov on 03.07.2022.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    var theme: Theme! {
        didSet {
            startNewGame()
        }
    }
    
    @Published private var model: MemoryGame<String>!
    
    init(theme: Theme) {
        self.theme = theme
        startNewGame()
    }
    
    private func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairs) { cardIndex in
            theme.emojis[cardIndex]
        }
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    var foregroundColor: Color {
        Color(rgbaColor: theme.color)
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
        model = createMemoryGame()
    }
}
