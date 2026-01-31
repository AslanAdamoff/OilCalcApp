
import SwiftUI

struct SettingsView: View {
    @ObservedObject var languageService = LanguageService.shared
    
    var body: some View {
        Form {
            // Language selection removed as app is now English-only
        }
        .navigationTitle("settings.title".localized())
    }
}
