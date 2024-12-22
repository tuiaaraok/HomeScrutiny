import SwiftUI

struct ArtistDetailsScreen: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var navigationPath: [AppScreens]
    
    let id: UUID
       
    @State private var artist: Artist = Artist(
        isSolo: true,
        name: "",
        genre: "",
        vocalistName:"",
        drummerName: "",
        guitaristName: "",
        groupPersons: []
    )
    
    @State private var isMenuVisible = false
    
    private let storage = Storage.shared
    
    var body: some View {
        VStack(spacing: 0) {
            
            TopBarView(title: artist.name, navigationPath: $navigationPath)
            
            ScrollView {
                
                VStack(spacing: 15) {
                    MainTextField(title: "Artist/Group name", text: $artist.name)
                        
                        
                    GenreSelectionView(title: "Genre", genre: $artist.genre, isMenuVisible: $isMenuVisible)
                        
                        
                    VStack(spacing: 15) {
                        MainTextField(title: "Vocalist name", text: $artist.vocalistName)
                        MainTextField(title: "Drummer name", text: $artist.drummerName)
                        MainTextField(title: "Guitarist name", text: $artist.guitaristName)
                    }
                    .opacity(artist.isSolo ? 0 : 1)
                    
                    ForEach($artist.groupPersons) { $groupPerson in
                        GroupPersonScreen(
                            groupPerson: $groupPerson
                        ).listRowBackground(Color.background)
                    }
                    .opacity(artist.isSolo ? 0 : 1)
                    
                }
                .padding(EdgeInsets(top: 55, leading: 32, bottom: 0, trailing: 32))
                    .disabled(true)
            }
            

            
        }
        .background(Color.background .ignoresSafeArea())
        
        .onAppear {
            getArtist()
        }
    }
    
    private func getArtist() {
        guard let foundArtist = storage.getArtistById(id) else { return }
        artist = foundArtist
    }
}

private struct GroupPersonScreen: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    @Binding var groupPerson: GroupPerson
    
    var body: some View {
        HStack(spacing: 16) {
            MainTextField(title: "Role", text: $groupPerson.role)
            MainTextField(title: "Name", text: $groupPerson.name)
        }
        .background(Color.background)
    }
    
}

#Preview {
    @Previewable @State var navigationPath: [AppScreens] = []
    AddArtistScreen(navigationPath: $navigationPath).environmentObject(ThemeManager.shared)
}






