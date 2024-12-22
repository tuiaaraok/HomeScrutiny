import SwiftUI

@available(iOS 16.0, *)
struct AddedApartmentView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var apartment: Apartment
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            Image(apartment.imageString)
                .frame(width: 94, height: 87)
            VStack(alignment: .leading, spacing: 10) {
                Text("Address: \(apartment.address)")
                Text("Number of rooms: \(apartment.numberOfRooms)")
                Text("Area: \(apartment.area)")
            }
            .customFont(.mainText)
            .foregroundStyle(Color.mainText)
        }
        .padding(EdgeInsets(top: 8, leading: 4, bottom: 10, trailing: 4))
        .frame(maxWidth: .infinity)
        .background(Color.itemsBackground)
        .cornerRadius(15)
        .shadow(color: Color.black, radius: 4, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}
