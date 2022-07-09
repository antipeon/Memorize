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
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(theme.emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onChange(of: removeEmoji) { removedEmojis in
                            theme.emojis.removeAll(where: { $0 == removedEmojis })
                        }
                        .onTapGesture {
                            if theme.emojis.count > 2 {
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
            ChooseColor(theme: $theme)
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
    }
    
    struct StepperView: View {
        @Binding var theme: Theme
        
        @State var incrementation = 0
        var body: some View {
            Stepper("\(theme.numberOfPairs) pairs", value: $incrementation, in: 2 - theme.numberOfPairs...theme.emojis.count - theme.numberOfPairs)
                .onChange(of: incrementation) { [incrementation] newIncrementation in
                    theme.numberOfPairs += (newIncrementation - incrementation)
                }
        }
        
//        private func incrementStep() {
//            let newNumber = theme.numberOfPairs + 1
//            if newNumber < theme.emojis.count {
//                theme.numberOfPairs = newNumber
//            }
//        }
//
//        private func decrementStep() {
//            let newNumber = theme.numberOfPairs - 1
//            if newNumber >= 2 {
//                theme.numberOfPairs = newNumber
//            }
//        }
        
        private var totalNumberOfPairs: Int {
            theme.numberOfPairs
        }
    }
    
    struct ChooseColor: View {
        @Binding var theme: Theme

        @State private var color: Color
        
        init(theme: Binding<Theme>) {
            self._theme = theme
            _color = State(initialValue: Color(rgbaColor: theme.wrappedValue.color))
        }

        var body: some View {
            ColorPicker(Constants.Headers.color, selection: $color, supportsOpacity: true)
                .onChange(of: color) { value in
                    theme.color = RGBAColor(color: value)
                }
        }
    }
}


extension Theme {
    var cgColor: Color {
        Color(rgbaColor: self.color)
    }
}




struct ThemeEditor_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditor(theme: .constant(ThemeStore().getTheme()))
    }
}
