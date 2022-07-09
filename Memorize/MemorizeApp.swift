//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Samat Gaynutdinov on 02.06.2022.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var themeStore = ThemeStore()
    
    
    var body: some Scene {
        WindowGroup {
            ThemeChooser()
                .environmentObject(themeStore)
        }
    }
}
