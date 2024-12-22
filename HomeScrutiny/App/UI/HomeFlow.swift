import SwiftUI

@available(iOS 17.0, *)
struct HomeFlow: View {
    
    @State var navPath: [Screens] = []
    
    var body: some View {
        NavigationStack(path: $navPath) {
            HomeScreen(navPath: $navPath)
                .navigationDestination(for: Screens.self) { screen in
                    switch screen {
                    case .home:
                        HomeScreen(navPath: $navPath)
                    case .apartmentDetails(let id):
                        ApartmentDetailsScreen(navPath: $navPath, id: id)
                    case .apartmentDetailsAdding(let id):
                        ApartmentDetailsAddingScreen(navPath: $navPath, id: id)
                    case .settings:
                        SettingsScreen(navPath: $navPath)
                    }
                }
        }
    }
}

enum Screens: Hashable {
    case home
    case apartmentDetails(UUID)
    case apartmentDetailsAdding(UUID)
    case settings
}
