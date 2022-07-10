//
//  Theme.swift
//  Memorize
//
//  Created by Samat Gaynutdinov on 03.07.2022.
//

import Foundation

struct Theme: Codable, Identifiable, Hashable {
    var emojis: [String] {
        didSet {
            numberOfPairs = min(numberOfPairs, emojis.count)
        }
    }
    var title: String
    var numberOfPairs: Int {
        didSet {
            let newIndices = emojis.indices
                .shuffled()
                .dropLast(emojis.count - numberOfPairs)
                .map {
                    emojis.firstIndex(of: emojis[$0])
                }
                .compactMap {
                    $0
                }
            
            playingEmojiIndices = newIndices
        }
    }
    var color: RGBAColor
    var id = UUID()
    
    var playingEmojiIndices: [Int]
    
    struct RGBAColor: Codable, Equatable, Hashable {
        let red: Double
        let green: Double
        let blue: Double
        let alpha: Double
    }
}
