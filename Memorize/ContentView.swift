//
//  ContentView.swift
//  Memorize
//
//  Created by Samat Gaynutdinov on 02.06.2022.
//

import SwiftUI

struct ContentView: View {
    @State var cardsCount = 3
    let themeCount: Int = 3
    @State var theme = ThemeChooser.getTheme(theme: .love)
    var body: some View { 
        VStack {
            Text("Memorize!")
                .font(.largeTitle)
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                    ForEach(theme.emojis[0..<cardsCount], id: \.self, content: {
                        emoji in
                        CardView(content: emoji).aspectRatio(2/3, contentMode: .fit)
                    })
                }
                .foregroundColor(.red)
            }
            HStack {
                ForEach(0..<themeCount) {
                    id in
                    let title = ThemeChooser.ThemeTitle(rawValue: id)
                    
                    if title != nil {
                        let nextTheme = ThemeChooser.getTheme(theme: title!)
                        
                        Button {
                            theme = ThemeChooser.getTheme(theme: nextTheme.themeTitle)
                        } label: {
                            VStack {
                                nextTheme.label
                                Text(nextTheme.title)
                                    .font(.title3)
                            }
                            
                            
                        }
                        if id != themeCount - 1 {
                            Spacer()
                        }
                    }
                    
                }
            }
            .font(.largeTitle)
            
            
        }
        .padding(.horizontal)
        
        
    }
}

struct CardView: View {
    @State var isFaceUp = true
    var content: String
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 30.0)
            if isFaceUp {
                shape
                    .fill()
                    .foregroundColor(.white)
                shape
                    .strokeBorder(lineWidth: 3)
                Text(content)
                    .font(.largeTitle)
            } else {
                shape.fill()
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
        ContentView()
            .preferredColorScheme(.dark)
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
        ["🎃", "👻", "😈", "🍭", "🦇", "🔪", "👹", "💀"],
        ["❤️", "💔", "💜", "💖", "💗", "💓", "😻", "👀"]
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
