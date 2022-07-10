//
//  ThemeChooser.swift
//  Memorize
//
//  Created by Samat Gaynutdinov on 07.07.2022.
//

import SwiftUI

struct ThemeChooser: View {
    
    @EnvironmentObject var themeStore: ThemeStore
    
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(themeStore.themes) { theme in
                    NavigationLink(destination: MemoryGameView(game: EmojiMemoryGame(theme: theme))) {
                        VStack(alignment: .leading) {
                            name(of: theme)
                                .font(.title2)
                            emojiAndCardsNumberInfo(for: theme)
                                .lineLimit(nil)
                        }
                        
                    }
                    .gesture(editMode == .active ? tapInEditMode(theme) : nil)
                    
                }
                .onDelete { indexSet in
                    themeStore.themes.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, newOffset in
                    themeStore.themes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
            }
            .navigationTitle("Choose theme")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        themeStore.addTheme(emojis: Constants.Theme.initialEmojis,
                                            title: Constants.Theme.initialTitle,
                                            numberOfPairs: Constants.Theme.initialNumberOfPairs,
                                            color: .red)
                        themeToEdit = themeStore.themes.last
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem {
                    EditButton()
                }
                
            }
            .sheet(item: $themeToEdit) { theme in
                ThemeEditor(theme: $themeStore.themes[theme])
            }
            .environment(\.editMode, $editMode)
        }
    }
    
    
    @State private var themeToEdit: Theme?
    
    func tapInEditMode(_ theme: Theme) -> some Gesture {
        TapGesture().onEnded {
            themeToEdit = theme
        }
    }
        
    private func emojiAndCardsNumberInfo(for theme: Theme) -> some View {
        Text(numberOfPairsString(from: theme) + " " + theme.emojis.joined())
    }
    
    private func numberOfPairsString(from theme: Theme) -> String {
        if theme.numberOfPairs == theme.emojis.count {
            return "All of"
        }
        return "\(theme.numberOfPairs) pairs from"
    }
    
    private func name(of theme: Theme) -> some View {
        Text(theme.title.capitalized)
            .foregroundColor(Color(rgbaColor: theme.color))
    }
    
    struct Constants {
        struct Theme {
            static let initialNumberOfPairs = 2
            static let initialEmojis = "😀😃"
            static let initialTitle = "New"
        }
    }
}

struct ThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        ThemeChooser()
            .environmentObject(ThemeStore())
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}
