//
//  ThemeEditor.swift
//  Memorize
//
//  Created by Samat Gaynutdinov on 09.07.2022.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: Theme
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                themeNameSection
                emojisSection
                addEmojiSection
                cardCountSection
                colorSection
            }
            .navigationTitle("Edit theme")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if presentationMode.wrappedValue.isPresented {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Close")
                        }
                    }
                }
            }
        }
        
    }
    
    // MARK: - Sections
    
    private var themeNameSection: some View {
        Section {
            TextField(Constants.Headers.themeName, text: $theme.title)
        } header: {
            Text(Constants.Headers.themeName)
        }
    }
    
    @State private var removeEmoji = ""
    
    private var emojisSection: some View {
        Section {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: Constants.Drawing.emojisSSectionFont))]) {
                ForEach(theme.emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onChange(of: removeEmoji) { removedEmoji in
                            theme.emojis.removeAll(where: { $0 == removedEmoji })
                        }
                        .onTapGesture {
                            if theme.emojis.count > Constants.Numbers.minNumberOfPairsAllowed {
                                removeEmoji = emoji
                            }
                        }
                }
                
            }
            .font(Font.system(size: Constants.Drawing.emojisSSectionFont))
        } header: {
            HStack {
                Text(Constants.Headers.emojis)
                Spacer()
                Text("Tap on emoji to remove")
                    .scaleEffect(Constants.Drawing.emojisSectionRightHeaderFontScale)
            }
        }
    }
    
    @State private var emojisToAdd = ""
    
    private var addEmojiSection: some View {
        Section {
            TextField("Add emoji".uppercased(), text: $emojisToAdd)
                .onChange(of: emojisToAdd) {
                    emojis in
                    addEmojis(emojis)
                }
        } header: {
            Text(Constants.Headers.addEmoji)
        }
    }
    
    private var cardCountSection: some View {
        Section {
            StepperView(theme: $theme)
        } header: {
            Text(Constants.Headers.cardCount)
        }
    }
    
    private var colorSection: some View {
        Section {
            ChooseColor(color: $theme.cgColor)
        } header: {
            Text(Constants.Headers.color)
        }
    }
    
    // MARK: - Helpers
    
    private func addEmojis(_ emojis: String) {
        theme.emojis = Array(Set(theme.emojis + Array(Set(emojis.map { String($0) }))))
    }
     
    struct Constants {
        struct Headers {
            static let themeName = "theme name".capitalized
            static let emojis = "emojis".capitalized
            static let addEmoji = "emoji".capitalized
            static let cardCount = "card count".capitalized
            static let color = "color".capitalized
        }
        
        struct Drawing {
            static let emojisSectionRightHeaderFontScale = 0.8
            static let emojisSSectionFont: CGFloat = 40
        }
        
        struct Numbers {
            static let minNumberOfPairsAllowed = 2
            static let stepperStep = 1
        }
    }
    
    struct StepperView: View {
        @Binding var theme: Theme
        
        var body: some View {
            Stepper("\(theme.numberOfPairs) pairs",
                    value: $theme.numberOfPairs,
                    in: Constants.Numbers.minNumberOfPairsAllowed...theme.emojis.count,
                    step: Constants.Numbers.stepperStep)
        }
    }
    
    struct ChooseColor: View {
        @Binding var color: Color
        
        var body: some View {
            ColorPicker(Constants.Headers.color, selection: $color, supportsOpacity: true)
        }
    }
}

extension Theme {
    var cgColor: Color {
        get {
            Color(rgbaColor: self.color)
        }
        set {
            color = RGBAColor(color: newValue)
        }
    }
}




struct ThemeEditor_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditor(theme: .constant(ThemeStore().themes.first!))
    }
}
