import SwiftUI

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @AppStorage("isLightTheme") var isLT: Bool = false
    
    private init() {}
}

extension Color {
    
    static var toggleBackground: Color {
        ThemeManager.shared.isLT ? .themeLight : .themeDark
    }
    
    static var themeBackground: Color {
        ThemeManager.shared.isLT ? .themeLight : .themeDark
    }
    
    static var contactBackground: Color {
        ThemeManager.shared.isLT ? .contactLight : .contactDark
    }
    
    static var privacyBackground: Color {
        ThemeManager.shared.isLT ? .privacyLight : .privacyDark
    }
    
    static var rateBackground: Color {
        ThemeManager.shared.isLT ? .rateLight : .rateDark
    }
    
    static var itemsBackground: Color {
        ThemeManager.shared.isLT ? .white : .darkItemsBackground
    }
    
    static var actionButtonTextColor: Color {
        ThemeManager.shared.isLT ? .white : .black
    }
        
    static var mainAdd: Color {
        ThemeManager.shared.isLT ? .mainLight : .mainDark
    }

    static var mainText: Color {
        ThemeManager.shared.isLT ? .black : .white
    }
    
    static var background: Color {
        ThemeManager.shared.isLT ? .backgroundLight : .backgroundDark
    }
}



