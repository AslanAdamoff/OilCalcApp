//
//  OilCalcAppApp.swift
//  OilCalcApp
//
//  Created by Aslan Adamov on 8/1/26.
//

import SwiftUI

@main
struct OilCalcAppApp: App {
    @ObservedObject var languageService = LanguageService.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.locale, .init(identifier: languageService.currentLanguage))
                .id(languageService.currentLanguage) // Force redraw when language changes
        }
    }
}
