import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import PhotosUI
import MapKit

@MainActor
class CreateViewModel: ObservableObject {
    @Published var title = ""
    @Published var description = ""
    @Published var phone = ""
    @Published var address = ""
    @Published var category: RequestType = .request
    @Published var selectedPhotos: [PhotosPickerItem] = []
    @Published var images: [UIImage] = []
    @Published var selectedCoordinate: CLLocationCoordinate2D? = nil
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 43.2565, longitude: 76.9285),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    @Published var isUploading = false

    func handlePhotoSelection() async {
        images = []
        for item in selectedPhotos {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                images.append(uiImage)
            }
        }
    }

    func publishRequest(completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        isUploading = true
        Task {
            var uploadedURLs: [String] = []
            uploadedURLs = try await ImageStorageManager
                .uploadAsJPEG(images: images, path: "requests/", compressionQuality: 0.5)
                .map { $0.absoluteString }
            let dbRef = Database.database().reference().child("requests").childByAutoId()
            let requestId = dbRef.key ?? UUID().uuidString
            let requestData: [String: Any] = [
                "id": requestId,
                "title": title,
                "description": description,
                "phoneNumber": phone,
                "address": address,
                "category": category.rawValue,
                "location": [
                    "latitude": selectedCoordinate?.latitude,
                    "longitude": selectedCoordinate?.longitude
                ],
                "imageUrls": uploadedURLs,
                "createdBy": userId
            ]
            do {
                try await dbRef.setValue(requestData)
                self.isUploading = false
            } catch {
                completion(false)
            }
        }
    }
}
