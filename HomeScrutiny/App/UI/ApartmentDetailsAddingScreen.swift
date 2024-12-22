import SwiftUI

@available(iOS 16.0, *)
struct ApartmentDetailsAddingScreen: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var navPath: [Screens]
    private let storage = Storage.shared
    @State private var apartment = Apartment(imageString: "", address: "", inProcess: false, area: "", numberOfRooms: "", defects: [])
    @State var defectName: String = ""
    let id: UUID
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                AddedApartmentView(apartment: $apartment)
                    .padding(EdgeInsets(top: 40, leading: 17, bottom: 0, trailing: 17))
                
                ActionButton(text: "ADD DEFECT", action: addDefect)
                    .padding(EdgeInsets(top: 27, leading: 45, bottom: 0, trailing: 45))
                
                ActionButton(text: "SAVE", action: saveAndBack)
                    .padding(EdgeInsets(top: 27, leading: 45, bottom: 0, trailing: 45))
                
                CategoryView(defectName: $defectName)
                    .padding(EdgeInsets(top: 27, leading: 45, bottom: 0, trailing: 45))
                
                
                List {
                    ForEach($apartment.defects) { $defect in
                        DefectAddingView(defect: $defect)
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
    
    private func addDefect() {
        let defect = Defect(name: defectName, description: "", image: nil)
        apartment.defects.append(defect)
    }
    
    private func saveAndBack() {
        if !navPath.isEmpty {
            storage.updateApartmentById(id, with: apartment)
            navPath.removeLast(navPath.count)
        }
    }
}

@available(iOS 16.0, *)
private struct DefectAddingView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var defect: Defect
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                
                Text(defect.name)
                    .customFont(.mainTitleText)
                
                MainTextField(title: "Description", text: $defect.description, axis: .vertical)
                
                ImageView(imageData: $defect.image)
                    .frame(maxWidth: 150, maxHeight: 150)
                    .padding(.top, 27)

            }
            .foregroundStyle(Color.mainText)
            .padding(.bottom, 18)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

private struct ImageView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var imageData: UIImageData?
    @State private var isImagePickerPresented = false
    
    var body: some View {
        VStack {
            Group {
                if let uiImage = imageData?.toUIImage() {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "photo.artframe.circle")
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 152)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.mainText, lineWidth: 2)
            )
            .onTapGesture {
                isImagePickerPresented = true
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker { selectedImage in
                    imageData = UIImageData(from: selectedImage)
                }
            }
        }
    }
}

private struct ImagePicker: UIViewControllerRepresentable {
    var onImagePicked: (UIImage) -> Void
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.onImagePicked(uiImage)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

@available(iOS 16.0, *)
private struct CategoryView: View {
    @EnvironmentObject var themeManager: ThemeManager
    private let storage = Storage.shared
    @Binding var defectName: String
    
    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(storage.categories, id: \.self) { categoryOption in
                    Button(action: {
                        defectName = categoryOption
                    }) {
                        Text(categoryOption.capitalized)
                            .customFont(.categoryButtonText)
                            .foregroundStyle(Color.mainText)
                            .padding(EdgeInsets(top: 5, leading: 0, bottom: 7, trailing: 0))
                            .frame(maxWidth: .infinity)
                            .background(defectName == categoryOption ? Color.mainAdd : Color.clear)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.mainText, lineWidth: 1)
                            )
                        
                    }
                }
            }
        }
    }
}
