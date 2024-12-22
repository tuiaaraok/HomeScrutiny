import SwiftUI

@available(iOS 16.0, *)
struct ActionButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                Text(text)
                    .customFont(.actionButtonText)
                    .foregroundStyle(Color.itemsBackground)
                    .padding(11)
            }
            .frame(maxWidth: .infinity, maxHeight: 46)
            .background(Color.mainAdd)
            .cornerRadius(8)            
        }
    }
}
