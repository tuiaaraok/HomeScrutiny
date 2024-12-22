import SwiftUI

class Storage {
    
    static let shared = Storage()
    
    let apartmentsImagesString = ["component1Dark", "component2Dark", "component1Light", "component2Light"]
    
    let categories = ["Walls", "Ceiling", "Floors", "Doors", "Windows", "Plumbing"]
    
    private let apartmentsKey = "apartmentsKey"
    
    private init() { }
        
    func updateApartmentById(_ id: UUID, with newApartment: Apartment) {
        var apartments = getApartments()
        
        if let index = apartments.firstIndex(where: { $0.id == id }) {
            apartments[index] = newApartment
            saveApartments(apartments)
        }
    }
    
    func saveApartment(_ apartment: Apartment) {
        var apartments = getApartments()
        apartments.append(apartment)
        saveApartments(apartments)
    }

    func saveApartments(_ apartments: [Apartment]) {
        if let data = try? JSONEncoder().encode(apartments) {
            UserDefaults.standard.set(data, forKey: apartmentsKey)
        }
    }
        
    func getApartmentsByAddressAndInProcess(address: String = "", inProcess: Bool? = nil) -> [Apartment] {
        let apartments = getApartments()
        
        return apartments.filter { apartment in
            var matches = true
            
            if !address.isEmpty {
                matches = matches && apartment.address.localizedCaseInsensitiveContains(address)
            }
            
            if let inProcess = inProcess {
                matches = matches && apartment.inProcess == inProcess
            }
            
            return matches
        }
    }

    func getApartmentById(_ id: UUID) -> Apartment? {
        let apartments = getApartments()
        return apartments.first { $0.id == id }
    }
    
    func getApartments() -> [Apartment] {
        guard let data = UserDefaults.standard.data(forKey: apartmentsKey),
              let apartments = try? JSONDecoder().decode([Apartment].self, from: data) else {
            return []
        }
        return apartments
    }
}

