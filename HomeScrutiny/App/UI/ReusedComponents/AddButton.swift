import SwiftUI

struct AddButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(themeManager.isLT == true ? "plusButtonLightIcon" : "plusButtonDarkIcon")
                .frame(maxWidth: 64, maxHeight: 64)
        }
    }
}
