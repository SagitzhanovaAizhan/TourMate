import UIKit
import FirebaseStorage

struct ImageStorageManager {
    static private let storage = Storage.storage()
    
    ///Uploads a multiple images as JPEGs and returns the URLs for the images
    ///Runs the uploads simultaneously
    static func uploadAsJPEG(images: [UIImage], path: String, compressionQuality: CGFloat = 1) async throws -> [URL]{
        return try await withThrowingTaskGroup(of: URL.self, body: { group in
            for image in images {
                group.addTask {
                    return try await uploadAsJPEG(image: image, path: path, compressionQuality: compressionQuality)
                }
            }
            var urls: [URL] = []
            for try await url in group {
                urls.append(url)
            }
            return urls
        })
    }
    
    ///Uploads a multiple images as JPEGs and returns the URLs for the images
    ///Runs the uploads one by one
    static func uploadAsJPEG1x1(images: [UIImage], path: String, compressionQuality: CGFloat = 1) async throws -> [URL]{
        var urls: [URL] = []
        for image in images {
            let url = try await uploadAsJPEG(image: image, path: path, compressionQuality: compressionQuality)
            urls.append(url)
        }
        return urls
    }
    
    ///Uploads a single image as a JPG and returns the URL for the image
    ///Runs the uploads simultaneously
    static func uploadAsJPEG(image: UIImage, path: String, compressionQuality: CGFloat = 1) async throws -> URL{
        guard let data = image.jpegData(compressionQuality: compressionQuality) else{
            throw ServiceError.unableToGetData
        }
        return try await upload(imageData: data, path: path)
    }
    
    ///Uploads Data to the designated path in `FirebaseStorage`
    static func upload(imageData: Data, path: String) async throws -> URL{
        let storageRef = storage.reference()
        let imageRef = storageRef.child("\(path)\(UUID().uuidString).jpeg")
        _ = try await imageRef.putDataAsync(imageData)
        return try await imageRef.downloadURL()
    }
    
    enum ServiceError: LocalizedError{
        case unableToGetData
    }
}
