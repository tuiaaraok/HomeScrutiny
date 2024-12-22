import SwiftUI

@available(iOS 16.0, *)
struct ApartmentDetailsScreen: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var navPath: [Screens]
    private let storage = Storage.shared
    @State private var apartment = Apartment(imageString: "", address: "", inProcess: false, area: "", numberOfRooms: "", defects: [])
    let id: UUID
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                AddedApartmentView(apartment: $apartment)
                    .padding(EdgeInsets(top: 40, leading: 17, bottom: 0, trailing: 17))
                
                ActionButton(text: "START CHECKING", action: { toApartmentDetailsAddingScreen(id: apartment.id) })
                    .padding(EdgeInsets(top: 27, leading: 45, bottom: 0, trailing: 45))
                
                ActionButton(text: "BACK", action: back)
                    .padding(EdgeInsets(top: 27, leading: 45, bottom: 0, trailing: 45))
                
                List {
                    ForEach(apartment.defects) { defect in
                        DefectView(defect: defect)
                            .listRowBackground(Color.clear)
                    }
                }
                .frame(height: 700)
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .padding(EdgeInsets(top: 34, leading: 20, bottom: 1, trailing: 20))
                
                
            }
            .onAppear {
                if let fetchedApartment = storage.getApartmentById(id) {
                    apartment = fetchedApartment
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .scrollIndicators(.hidden)
        .background(Color.background.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }
    
    private func back() {
        if !navPath.isEmpty {
            navPath.removeLast()
        }
    }
    
    private func toApartmentDetailsAddingScreen(id: UUID) {
        navPath.append(Screens.apartmentDetailsAdding(id))
    }
}

@available(iOS 16.0, *)
private struct DefectView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let defect: Defect
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                
                Text(defect.name)
                    .customFont(.mainTitleText)
                
                Text("Description: \(defect.description)")
                    .customFont(.mainText)
                    .padding(.top, 15)
                
                ImageViewStatic(imageData: defect.image)
                    .frame(maxWidth: 150, maxHeight: 150)
                    .padding(.top, 5)

            }
            .foregroundStyle(Color.mainText)
            .padding(.bottom, 18)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
