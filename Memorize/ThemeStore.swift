//
//  ThemeStore.swift
//  Memorize
//
//  Created by Samat Gaynutdinov on 06.07.2022.
//

import SwiftUI

class ThemeStore: ObservableObject {
    
    var currentTheme: Theme!
    
    // MARK: Intent(s)
    func addTheme(emojis: String, title: String, numberOfPairs: Int, color: Color) {
        themes.append(ThemeStore.createThemeWithComponents(emojis: Set(emojis.map { String($0) }),
                                                                  title: title,
                                                                  numberOfPairs: numberOfPairs,
                                                                  color: Theme.RGBAColor(color: color)))
    }

    func loadNewTheme() {
        currentTheme = getTheme()
    }
    
    struct Autosave {
        static let filename = "Themechooser"
        static var url: URL? {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            return documentDirectory?.appendingPathComponent(filename)
        }
    }
    
    private func autoSave() {
        if let url = Autosave.url {
            save(to: url)
        }
    }
    
    private func save(to url: URL) {
        let thisFunction = "\(String(describing: self)).\(#function)"
        do {
            let data = try json()
            print("\(thisFunction) json: \(String(data: data, encoding: .utf8) ?? "nil")")
            try data.write(to: url)
            print("\(thisFunction) successfully encoded")
        } catch let encodingError where encodingError is EncodingError {
            print("\(thisFunction) couldn't encode themeChooser: \(encodingError.localizedDescription)")
        } catch {
            print("\(thisFunction) error = \(error)")
        }
    }
    
    init(themes: [Theme]) {
        self.themes = themes
        loadNewTheme()
    }
    
    convenience init() {
        if let url = ThemeStore.Autosave.url, let themes = try? ThemeStore.getThemesFromURL(url: url) {
            self.init(themes: themes)
        } else {
            self.init(themes: ThemeStore.getInitialThemes())
        }
        
    }
    
    private static func getInitialThemes() -> [Theme] {
        var themes = [Theme]()
        themes.append(createThemeWithComponents(emojis: ThemeStore.emojis.first!,
                                                title: "faces",
                                                numberOfPairs: 4,
                                                color: Theme.RGBAColor(color: Color.red)))
        themes.append(createThemeWithComponents(emojis: ThemeStore.emojis[1],
                                                title: "spooky",
                                                numberOfPairs: 5,
                                                color: Theme.RGBAColor(color: Color.orange)))
        themes.append(createThemeWithComponents(emojis: ThemeStore.emojis.last!,
                                                title: "love",
                                                numberOfPairs: 3,
                                                color: Theme.RGBAColor(color: Color.blue)))
        return themes
    }
    
    private static var emojis: [Set<String>] = [
        ["😀", "😍", "😇", "🤪", "😎", "😡", "😤", "😈", "🤢", "🥶" ,"🤡"],
        ["🎃", "👻", "😈", "🍭", "🦇", "🔪", "👹", "💀", "👁", "🦾"],
        ["❤️", "💔", "💜", "💖", "💗", "💓", "😻", "👀", "👚", "👨‍👩‍👦‍👦"]
    ]
    
    var themes: [Theme]
    
    private static func createThemeWithComponents(emojis: Set<String>,
                                                  title: String,
                                                  numberOfPairs: Int,
                                                  color: Theme.RGBAColor) -> Theme {
        let emojisArray = Array(emojis)
        let emojisCount = min(emojisArray.count, numberOfPairs)
        var indices = emojisArray.indices.shuffled()
        indices.removeLast(indices.count - emojisCount)
        return Theme(emojis: emojisArray,
                     title: title.capitalized,
                     numberOfPairs: emojisCount,
                     color: color,
                     playingEmojiIndices: indices.map { indices.firstIndex(of: $0)! })
    }
    
    func getTheme() -> Theme {
        return themes[themes.count.random()]
    }
}

extension ThemeStore {
    func json() throws -> Data {
        try JSONEncoder().encode(themes)
    }
}

extension ThemeStore {
    private static func getThemesFromJson(json: Data) throws -> [Theme] {
        return try JSONDecoder().decode([Theme].self, from: json)
    }
    
    private static func getThemesFromURL(url: URL) throws -> [Theme] {
        let data = try Data(contentsOf: url)
        return try getThemesFromJson(json: data)
    }
}
