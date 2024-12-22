import Foundation
import SwiftUI

enum CustomFonts: String {
    case Commissioner = "Commissioner"
    
}

struct FontBuilder {
    
    let font: Font
    let tracking: Double
    let lineSpacing: Double
    let verticalPadding: Double
    
    init(
        customFont: CustomFonts,
        fontSize: Double,
        weight: Font.Weight = .regular,
        letterSpacing: Double = 0,
        lineHeight: Double
    ) {
        self.font = Font.custom(customFont, size: fontSize).weight(weight)
        self.tracking = fontSize * letterSpacing

        let uiFont = UIFont(name: customFont.rawValue, size: fontSize) ?? .systemFont(ofSize: fontSize)
        self.lineSpacing = lineHeight - uiFont.lineHeight
        self.verticalPadding = self.lineSpacing / 2
    }
    
}

extension FontBuilder {
    
    
    static let settingsButtonText = FontBuilder(
        customFont: .Commissioner,
        fontSize: 24,
        weight: .medium,
        lineHeight: 29
    )
    
    static let actionButtonText = FontBuilder(
        customFont: .Commissioner,
        fontSize: 20,
        weight: .medium,
        lineHeight: 24
    )
    
    static let mainText = FontBuilder(
        customFont: .Commissioner,
        fontSize: 18,
        weight: .regular,
        lineHeight: 21
    )
    
    static let mainTitleText = FontBuilder(
        customFont: .Commissioner,
        fontSize: 16,
        weight: .bold,
        lineHeight: 21
    )
    
    static let categoryButtonText = FontBuilder(
        customFont: .Commissioner,
        fontSize: 16,
        weight: .regular,
        lineHeight: 19
    )
    
}

extension Font {
    static func custom(_ fontName: CustomFonts, size: Double) -> Font {
        Font.custom(fontName.rawValue, size: size)
    }
}


@available(iOS 16.0, *)
struct CustomFontsModifire: ViewModifier {

    private let fontBuilder: FontBuilder

    init(_ fontBuilder: FontBuilder) {
        self.fontBuilder = fontBuilder
    }

    func body(content: Content) -> some View {
        content
            .font(fontBuilder.font)
            .lineSpacing(fontBuilder.lineSpacing)
            .padding([.vertical], fontBuilder.verticalPadding)
            .tracking(fontBuilder.tracking)
    }

}

@available(iOS 16.0, *)
extension View {
    func customFont(_ fontBuilder: FontBuilder) -> some View {
        modifier(CustomFontsModifire(fontBuilder))
    }
}

