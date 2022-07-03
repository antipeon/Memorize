//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Samat Gaynutdinov on 02.06.2022.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let memoryGame = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(game: memoryGame)
        }
    }
}
