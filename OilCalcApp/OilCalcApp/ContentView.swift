//
//  ContentView.swift
//  OilCalcApp
//
//  Created by Aslan Adamov on 8/1/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MainCalcView()
                .tabItem {
                    Label("mainScreen.mainCalc".localized(), systemImage: "function")
                }
            
            TripCalcView()
                .tabItem {
                    Label("mainScreen.tripCalc".localized(), systemImage: "arrow.triangle.swap")
                }
            
            NavigationStack {
                HistoryView()
            }
            .tabItem {
                Label("history.title".localized(), systemImage: "clock.arrow.circlepath")
            }
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("settings.title".localized(), systemImage: "gear")
            }
        }
    }
}

#Preview {
    ContentView()
}
