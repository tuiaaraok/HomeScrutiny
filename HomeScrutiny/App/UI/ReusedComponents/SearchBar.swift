import SwiftUI

@available(iOS 16.0, *)
struct SearchBar: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var searchRequestText: String
    var searchAction: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            TextField(text: $searchRequestText) {
                HStack(spacing: 16) {
                    Text("Search..")
                        .customFont(.mainText)
                        .foregroundStyle(Color.gray)
                }
            }
            .foregroundStyle(Color.mainText)
            .customFont(.mainText)
            .padding(EdgeInsets(top: 14, leading: 50, bottom: 15, trailing: 19))
            .frame(maxHeight: 43)
            .background(Color.itemsBackground)
            .cornerRadius(15)
            .overlay {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Color.gray)
                        .padding(.leading, 14)
                    Spacer()
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gray, lineWidth: 1)
            )
            
            Button(action: searchAction) {
                Text("Search")
                    .customFont(.mainText)
                    .padding(14)
                    .foregroundStyle(Color.itemsBackground)
                    .frame(maxHeight: 43)
                    .background(Color.mainAdd)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
        }
        
    }
}
