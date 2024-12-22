import SwiftUI

@available(iOS 16.0, *)
struct MainTextField: View {
    @EnvironmentObject var themeManager: ThemeManager
    var title: String
    @Binding var text: String
    var placeholder: String = ""
    var axis: Axis = .horizontal
    var keyboardType: UIKeyboardType = .default
    var maxHeight: CGFloat = 43
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(title)
                .customFont(.mainText)
                .foregroundStyle(Color.mainText)
            TextField(text: $text, axis: axis) {
                Text(placeholder)
                    .customFont(.mainText)
                    .foregroundStyle(Color.mainText)
                    .keyboardType(keyboardType)
            }
            .foregroundStyle(Color.mainText)
            .customFont(.mainText)
            .padding(12)
            .background(Color.itemsBackground)
            .frame(maxHeight: maxHeight)
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.mainAdd, lineWidth: 2)
            )
        }
    }
}
