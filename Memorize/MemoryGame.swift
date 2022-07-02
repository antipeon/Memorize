//
//  MemoryGame.swift
//  Memorize
//
//  Created by Samat Gaynutdinov on 03.07.2022.
//

import Foundation

struct MemoryGame<CardContent> {
    var cards: Array<Card>
    
    init(numberOfPairsOfCards: Int, makeCardContent: (Int) -> CardContent) {
        cards = []
        for cardIndex in 0..<numberOfPairsOfCards {
            let newCard = Card(content: makeCardContent(cardIndex))
            cards.append(newCard)
            cards.append(newCard)
        }
    }
    
    func choose(_ card: Card) {
        
    }
    
    struct Card {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
    }
}
