//
//  ContentView.swift
//  Memorize
//
//  Created by Samat Gaynutdinov on 02.06.2022.
//

import SwiftUI

struct ContentView: View {
    @State var cardsCount = 10
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
                    .scaleEffect(2.0)
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
//        ContentView()
//            .preferredColorScheme(.dark)
    }
}
