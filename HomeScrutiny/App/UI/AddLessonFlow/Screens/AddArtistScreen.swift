import SwiftUI

struct AddArtistScreen: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var navigationPath: [AppScreens]
    
    @State private var isSolo: Bool = true
    @State private var artistName: String = ""
    @State private var genre: String = ""
    @State private var vocalistName: String = ""
    @State private var drummerName: String = ""
    @State private var guitaristName: String = ""
    @State private var groupPersons: [GroupPerson] = []
    
    @State private var isMenuVisible = false
    
    private let storage = Storage.shared
    
    var body: some View {
        VStack(spacing: 0) {
            
            TopBarView(title: "Add group", navigationPath: $navigationPath)
            
            ToggleView(isSmth: $isSolo, positiveButtonLabel: "Solo", negativeButtonLabel: "Group")
            ScrollView {
                
                VStack(spacing: 15) {
                    MainTextField(title: "Artist/Group name", text: $artistName)
                    
                    GenreSelectionView(title: "Genre", genre: $genre, isMenuVisible: $isMenuVisible)
                    
                    if isMenuVisible {
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(Storage.genresObjects) { genresObjects in
                                    Button(action: {
                                        genre = genresObjects.name
                                        isMenuVisible = false
                                    }) {
                                        Text(genresObjects.name)
                                            .customFont(.textFieldText)
                                            .foregroundColor(Color.mainText)
                                            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                                    }
                                    Divider()
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                        .background(Color.background)
                        .cornerRadius(6)
                        .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
                        .frame(maxHeight: 200)
                    }
                    
                    VStack(spacing: 15) {
                        MainTextField(title: "Vocalist name", text: $vocalistName)
                        MainTextField(title: "Drummer name", text: $drummerName)
                        MainTextField(title: "Guitarist name", text: $guitaristName)
                    }
                    .opacity(isSolo ? 0 : 1)
                    .disabled(isSolo)
                    
                    ForEach($groupPersons) { $groupPerson in
                        GroupPersonScreen(
                            groupPerson: $groupPerson
                        ).listRowBackground(Color.background)
                    }
                    .onDelete { indexSet in
                        groupPersons.remove(atOffsets: indexSet)
                    }
                    .opacity(isSolo ? 0 : 1)
                    .disabled(isSolo)
                    
                    
                    
                    
                    
                }.padding(EdgeInsets(top: 55, leading: 32, bottom: 0, trailing: 32))
            }
            
            
            AddButton(title: "Add a participant", action: addNewGroupPerson)
                .padding(.top, 15)
                .opacity(isSolo ? 0 : 1)
                .disabled(isSolo)
            
            MainButton(text: "Save", action: saveArtistAndExit)
                .padding(.top, 15)
            
        }
        .background(Color.background .ignoresSafeArea())
        
    }
    
    private func addNewGroupPerson() {
        let newGroupPerson = GroupPerson(role: "", name: "")
        groupPersons.append(newGroupPerson)
    }
    
    private func saveArtistAndExit() {
        let artist = Artist(
            isSolo: isSolo,
            name: artistName,
            genre: genre,
            vocalistName: isSolo ? "" : vocalistName,
            drummerName: isSolo ? "" : drummerName,
            guitaristName: isSolo ? "" : guitaristName,
            groupPersons: isSolo ? [] : groupPersons
        )
        storage.saveArtist(artist)
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
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






