//
//  ContentView.swift
//  Memorize
//
//  Created by Samat Gaynutdinov on 02.06.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game: EmojiMemoryGame

    var body: some View {
        VStack {
            Text(game.themeName)
                .font(.largeTitle)
            ScrollView {
                cardsContent
            }
            HStack {
                newGameButton
                Spacer()
                score
            }
        }
        .padding(.horizontal)
    }
    
    private var cardsContent: some View {
        LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
            ForEach(game.cards, content: {
                card in
                CardView(card: card).aspectRatio(2/3, contentMode: .fit)
                    .onTapGesture {
                        game.choose(card)
                    }
            })
        }
        .foregroundColor(game.foregroundColor.toUIColor())
    }
    
    private var newGameButton: some View {
        Button {
            game.startNewGame()
        } label: {
            Image(systemName: "arrow.counterclockwise").font(.largeTitle)
        }
    }
    
    private var score: some View {
        Text(game.score)
            .font(.largeTitle)
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 30.0)
            if card.isFaceUp {
                shape
                    .fill()
                    .foregroundColor(.white)
                shape
                    .strokeBorder(lineWidth: 3)
                Text(card.content)
                    .font(.largeTitle)
                    .scaleEffect(2.0)
            } else if card.isMatched {
                shape.opacity(0.0)
            } else {
                shape.fill()
            }
        }
    }
}


extension ThemeChooser.Theme.Color {

    func toUIColor() -> Color {
        switch self {
        case .orange:
            return Color.orange
        case .blue:
            return Color.blue
        case .red:
            return Color.red
        }
    }
}











struct ContentView_Previews: PreviewProvider {
        
    static var previews: some View {
        let game = EmojiMemoryGame()

        ContentView(game: game)
            .preferredColorScheme(.light)
    }
}
