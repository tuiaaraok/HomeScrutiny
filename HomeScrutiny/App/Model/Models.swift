import Foundation
import UIKit

struct Apartment: Identifiable, Codable {
    let id: UUID
    
    var imageString: String
    
    var address: String
    var inProcess: Bool
    
    var area: String
    var numberOfRooms: String
    
    var defects: [Defect]
    
    init(id: UUID = UUID(), imageString: String, address: String, inProcess: Bool, area: String, numberOfRooms: String, defects: [Defect]) {
        self.id = id
        
        self.imageString = imageString
        
        self.address = address
        self.inProcess = inProcess
        
        self.area = area
        self.numberOfRooms = numberOfRooms
        
        self.defects = defects
        
    }
}

struct Defect: Identifiable, Codable {
    let id: UUID
    
    var name: String
    var description: String
    var image: UIImageData?

    init(id: UUID = UUID(), name: String, description: String, image: UIImageData?) {
        self.id = id
        self.name = name
        self.description = description
        self.image = image
    }
}

struct UIImageData: Codable {
    var imageData: Data
    
    init(from image: UIImage) {
        self.imageData = image.jpegData(compressionQuality: 0.8) ?? Data()
    }
    
    func toUIImage() -> UIImage? {
        return UIImage(data: imageData)
    }
}






