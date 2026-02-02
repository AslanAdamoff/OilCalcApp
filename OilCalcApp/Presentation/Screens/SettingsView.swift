
import SwiftUI

struct SettingsView: View {
    @ObservedObject var languageService = LanguageService.shared
    @State private var showShareSheet = false
    
    var body: some View {
        Form {
            Section {
                NavigationLink(destination: AboutView()) {
                    Label("settings.about".localized(), systemImage: "info.circle")
                }
            }
            
            Section {
                Button(action: {
                    showShareSheet = true
                }) {
                    Label("settings.share".localized(), systemImage: "square.and.arrow.up")
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                }
            }
        }
        .navigationTitle("settings.title".localized())
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: ["OilCalcApp - Petroleum Calculator & Loss Analysis Tool"])
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
