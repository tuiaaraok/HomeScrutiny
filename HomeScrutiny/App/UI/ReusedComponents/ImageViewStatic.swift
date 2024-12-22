import SwiftUI

struct ImageViewStatic: View {
    let imageData: UIImageData?
    
    var body: some View {
        VStack {
            if let uiImage = imageData?.toUIImage() {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 315, maxHeight: 450)
            }
        }
    }
}
