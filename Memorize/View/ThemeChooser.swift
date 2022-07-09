//
//  ThemeChooser.swift
//  Memorize
//
//  Created by Samat Gaynutdinov on 07.07.2022.
//

import SwiftUI

struct ThemeChooser: View {
    
    @EnvironmentObject var themeStore: ThemeStore {
        didSet {
            fillGameByThemeIdInfo()
        }
    }
    
    @State private var editMode: EditMode = .inactive

    
    @State var emojiMemoryGameByThemeId: Dictionary<UUID, EmojiMemoryGame> = [:]
    
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
                EditButton()
            }
            .sheet(item: $themeToEdit) { theme in
                ThemeEditor(theme: $themeStore.themes[theme])
            }
            .environment(\.editMode, $editMode)
        }
        .onAppear {
            fillGameByThemeIdInfo()
        }
    }
    
    private func fillGameByThemeIdInfo() {
        for theme in themeStore.themes {
            emojiMemoryGameByThemeId[theme.id] = EmojiMemoryGame(theme: theme)
        }
    }
    
    private func emojiMemoryGameByThemeId(id: UUID) -> EmojiMemoryGame {
        if let game = emojiMemoryGameByThemeId[id] {
            return game
        }
        guard let theme = themeStore.themes.first(where: {
            $0.id == id
        }) else {
            fatalError("no such theme")
        }
        let game = EmojiMemoryGame(theme: theme)
        emojiMemoryGameByThemeId[id] = game
        return emojiMemoryGameByThemeId[id]!
    }
    
    @State private var themeToEdit: Theme?
    
    func tapInEditMode(_ theme: Theme) -> some Gesture {
        TapGesture().onEnded {
            themeToEdit = theme
        }
    }
    
    private func navigationLinkToMemoryGameView(for theme: Theme) -> some View {
        NavigationLink(destination: MemoryGameView(game: EmojiMemoryGame(theme: theme))) {
            navigationLinkBody(for: theme)
        }
    }
    
    private func navigationLinkBody(for theme: Theme) -> some View {
        VStack(alignment: .leading) {
            name(of: theme)
                .font(.title2)
            emojiAndCardsNumberInfo(for: theme)
                .lineLimit(nil)
        }
    }
    
    private func navigationLinkToEditTheme(for theme: Theme) -> some View {
        NavigationLink(destination: ThemeEditor(theme: $themeStore.themes[theme])) {
            navigationLinkBody(for: theme)
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
}

struct ThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        ThemeChooser()
            .environmentObject(ThemeStore())
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}
