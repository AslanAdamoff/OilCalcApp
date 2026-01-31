import SwiftUI

enum DesignSystem {
    enum Colors {
        static let background = Color(.systemGray6)
        static let cardBackground = Color(.secondarySystemBackground)
        static let accent = Color.orange // Oil/Gold theme
        static let textPrimary = Color.primary
        static let textSecondary = Color.secondary
    }
    
    enum Fonts {
        static func title() -> Font {
            .system(.largeTitle, design: .rounded).weight(.bold)
        }
        
        static func header() -> Font {
            .system(.title2, design: .rounded).weight(.bold)
        }
        
        static func label() -> Font {
            .system(.headline, design: .rounded)
        }
        
        static func body() -> Font {
            .system(.body, design: .rounded)
        }
    }
    
    enum Layout {
        static let padding: CGFloat = 16
        static let cardCornerRadius: CGFloat = 16
        static let spacing: CGFloat = 20
        static let interItemSpacing: CGFloat = 12
    }
    
    struct CardView<Content: View>: View {
        let padding: CGFloat
        let spacing: CGFloat
        let content: Content
        
        init(
            padding: CGFloat = Layout.padding,
            spacing: CGFloat = Layout.interItemSpacing,
            @ViewBuilder content: () -> Content
        ) {
            self.padding = padding
            self.spacing = spacing
            self.content = content()
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: spacing) {
                content
            }
            .padding(padding)
            .background(Colors.cardBackground)
            .cornerRadius(Layout.cardCornerRadius)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}

// Helper extension for easy usage
extension View {
    func cardStyle() -> some View {
        self
            .padding(DesignSystem.Layout.padding)
            .background(DesignSystem.Colors.cardBackground)
            .cornerRadius(DesignSystem.Layout.cardCornerRadius)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
