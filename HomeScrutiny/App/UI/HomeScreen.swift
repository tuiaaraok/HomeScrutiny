import SwiftUI

@available(iOS 17.0, *)
struct HomeScreen: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var navPath: [Screens]
    private let storage = Storage.shared
    @State private var apartments: [Apartment] = []
    @State private var address = ""
    @State private var isActive: Bool? = nil
    @State private var showAddApartmentSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SearchBar(searchRequestText: $address) {
                getFilteredApartments()
            }
            .padding(EdgeInsets(top: 40, leading: 17, bottom: 0, trailing: 17))
            
            Text("List of apartments")
                .customFont(.mainTitleText)
                .padding(EdgeInsets(top: 19, leading: 17, bottom: 0, trailing: 0))
            
            ThreeButtonsView(isActive: $isActive)
                .padding(EdgeInsets(top: 13, leading: 17, bottom: 0, trailing: 17))
            
            List {
                ForEach(apartments) { apartment in
                    ApartmentView(apartment: apartment)
                        .onTapGesture {
                            toApartmentDetailsScreen(id: apartment.id)
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                }
                
                .onDelete { indexSet in
                    for index in indexSet {
                        if apartments[index].inProcess {
                            apartments[index].inProcess = false
                            storage.saveApartments(apartments)
                        }
                    }
                    getFilteredApartments()
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .padding(EdgeInsets(top: 34, leading: 17, bottom: 1, trailing: 17))
            
            HStack {
                SettingsButton(action: { navPath.append(Screens.settings) })
                Spacer()
                AddButton(action: { showAddApartmentSheet = true })
            }.padding(EdgeInsets(top: 5, leading: 29, bottom: 29, trailing: 29))
        }
        .onChange(of: isActive) {
            getFilteredApartments()
        }
        .onChange(of: showAddApartmentSheet) {
            getFilteredApartments()
        }
        .onAppear {
            apartments = storage.getApartments()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background.ignoresSafeArea())
        .sheet(isPresented: $showAddApartmentSheet) {
            AddingApartmentView()
                .presentationCornerRadius(30)
                .presentationDetents([.height(400)])
                .presentationBackground(Color.itemsBackground)
                .presentationDragIndicator(.visible)
            
        }
    }
    
    private func toApartmentDetailsScreen(id: UUID) {
        navPath.append(Screens.apartmentDetails(id))
    }
    
    private func getFilteredApartments() {
        apartments = storage.getApartmentsByAddressAndInProcess(address: address, inProcess: isActive)
    }
}

private struct SettingsButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "gearshape.fill")
                .resizable()
                .foregroundStyle(Color.mainAdd)
                .frame(maxWidth: 64, maxHeight: 64)
        }
    }
}

@available(iOS 16.0, *)
private struct AddingApartmentView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    private let storage = Storage.shared
    @State private var address: String = ""
    @State private var area: String = ""
    @State private var numberOfRooms: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 17) {
                MainTextField(title: "Address", text: $address)
                HStack(spacing: 14) {
                    MainTextField(title: "Area", text: $area)
                    MainTextField(title: "Number of rooms", text: $numberOfRooms)
                }
                ActionButton(text: "SAVE", action: { saveApartment() })
            }
            .padding(EdgeInsets(top: 78, leading: 45, bottom: 78, trailing: 45))
        }
    }
    
    private func saveApartment() {
        
        let apartment = Apartment(
            imageString: storage.apartmentsImagesString.randomElement() ?? "component2Light",
            address: address,
            inProcess: true,
            area: area,
            numberOfRooms: numberOfRooms, defects: [])
        storage.saveApartment(apartment)
        dismiss()
    }
    
}

@available(iOS 16.0, *)
private struct ThreeButtonsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var isActive: Bool?
    
    var body: some View {
        HStack(spacing: 0) {
            HomeToggleButton(isActive: $isActive, action: { isActive = nil }, title: "All", backgroundColor: (isActive == nil ? Color.mainAdd : Color.clear))
            Spacer()
            HomeToggleButton(isActive: $isActive, action: { isActive = true }, title: "In pocess", backgroundColor: (isActive == true ? Color.mainAdd : Color.clear))
            Spacer()
            HomeToggleButton(isActive: $isActive, action: { isActive = false }, title: "Completed", backgroundColor: (isActive == false ? Color.mainAdd : Color.clear))
        }
        
    }
}

@available(iOS 16.0, *)
private struct HomeToggleButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var isActive: Bool?
    let action: () -> Void
    let title: String
    var backgroundColor: Color
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .customFont(.categoryButtonText)
                .foregroundStyle(Color.mainText)
                .padding(EdgeInsets(top: 5, leading: 25, bottom: 7, trailing: 25))
                .background(backgroundColor)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.mainText, lineWidth: 1)
                )
        }
    }
}

@available(iOS 16.0, *)
private struct ApartmentView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let apartment: Apartment
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            Image(apartment.imageString)
                .frame(width: 94, height: 87)
            VStack(alignment: .leading, spacing: 10) {
                Text("Address: \(apartment.address)")
                Text("Status: \(apartment.inProcess ? "In process" : "Completed")")
            }
            .customFont(.mainText)
            .foregroundStyle(Color.mainText)
            Spacer()
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
