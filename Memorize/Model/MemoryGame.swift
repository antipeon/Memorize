//
//  MemoryGame.swift
//  Memorize
//
//  Created by Samat Gaynutdinov on 03.07.2022.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    var cards: Array<Card>
    
    private(set) var scoreTracker: ScoreTracker
    
    init(numberOfPairsOfCards: Int, makeCardContent: (Int) -> CardContent) {
        cards = []
        scoreTracker = ScoreTracker(numberOfPairsOfCards: numberOfPairsOfCards)
        for cardIndex in 0..<numberOfPairsOfCards {
            let content = makeCardContent(cardIndex)
            cards.append(Card(id: cardIndex * 2, content: content))
            cards.append(Card(id: cardIndex * 2 + 1, content: content))
        }
        cards.shuffle()
    }
    
    mutating func choose(_ card: Card) {
        guard let cardIndex = cards.index(matching: card),
                              !cards[cardIndex].isFaceUp,
                              !cards[cardIndex].isMatched else {
            return
        }
        
        if let faceUpCardIndex = cards.indexOfOneAndOnly({ card in
            card.isFaceUp
        }), faceUpCardIndex != cardIndex {
            if cards[faceUpCardIndex].content == cards[cardIndex].content {
                cards[faceUpCardIndex].isMatched = true
                cards[cardIndex].isMatched = true
                print("match happened")
                scoreTracker.rewardForMatch()
            } else {
                print("mismatch happened")
                scoreTracker.penalizeForMismatch(cardIndices: [faceUpCardIndex, cardIndex])
            }
        } else {
            for index in cards.indices {
                cards[index].isFaceUp = false
            }
        }
        cards[cardIndex].isFaceUp.toggle()
        if cards[cardIndex].isFaceUp {
            scoreTracker.seen[cardIndex] = true
        }
    }
    
    struct Card: Identifiable {
        var id: Int
        
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
    }
}

struct ScoreTracker {
    var seen: [Bool]
    private(set) var score = 0
    
    init(numberOfPairsOfCards: Int) {
       seen = Array<Bool>(repeating: false, count: 2 * numberOfPairsOfCards)
    }
    
    mutating func penalizeForMismatch(cardIndices: [Int]) {
        for index in cardIndices {
            if seen[index] {
                score -= Constants.mismatchPenalty
            }
        }
    }
    
    mutating func rewardForMatch() {
        score += Constants.matchReward
    }
    
    struct Constants {
        static let mismatchPenalty = 1
        static let matchReward = 2
    }
}
