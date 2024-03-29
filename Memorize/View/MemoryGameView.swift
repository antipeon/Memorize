//
//  MemoryGameView.swift
//  Memorize
//
//  Created by Samat Gaynutdinov on 02.06.2022.
//

import SwiftUI

struct MemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    
    var body: some View {
        VStack {
            cardsContent
            HStack {
                newGameButton
                Spacer()
                score
            }
        }
        .navigationTitle(game.themeName.capitalized)
        .padding(.horizontal)
    }
    
    private var cardsContent: some View {
        AspectVGrid(items: game.cards, aspectRatio: Constants.cardAspectRatio) { card in
            if card.isMatched && !card.isFaceUp {
                Color.clear
            } else {
                CardView(card: card)
                    .padding(Constants.paddingLengthInGrid)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: Constants.cardChooseAnimationDuration)) {
                            game.choose(card)
                        }
                    }
            }
        }
        .foregroundColor(game.foregroundColor)
        .padding()
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
    
    struct Constants {
        static let cardAspectRatio: CGFloat = 2/3
        static let cardChooseAnimationDuration = 1.0
        static let paddingLengthInGrid: CGFloat = 4
    }
}


struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            Text(card.content)
                .rotationEffect(Angle(degrees: card.isMatched && card.isFaceUp ? 360 : 0))
                .animation(Animation.linear(duration: Constants.matchEffectAnimationDuration).repeatForever(autoreverses: false))
                .font(Font.system(size: Constants.fontSize))
                .scaleEffect(scale(thatFits: geometry.size))
                .cardify(isFaceUp: card.isFaceUp, isMatched: card.isMatched)
        }
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * Constants.fontScale)
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (Constants.fontSize / Constants.fontScale)
    }
    
    struct Constants {
        static let fontScale = 0.8
        static let fontSize: CGFloat = 32
        static let matchEffectAnimationDuration = 1.0
    }
}











struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        let game = EmojiMemoryGame(theme: ThemeStore().themes.first!)
        MemoryGameView(game: game)
    }
}
