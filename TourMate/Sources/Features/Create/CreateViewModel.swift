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
    @Published var category = ""
    @Published var selectedPhotos: [PhotosPickerItem] = []
    @Published var images: [UIImage] = []
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
            let storage = Storage.storage()

            for image in images {
                if let data = image.jpegData(compressionQuality: 0.8) {
                    let ref = storage.reference(withPath: "requests/\(UUID().uuidString).jpg")
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/jpeg"

                    do {
                        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                            ref.putData(data, metadata: metadata) { _, error in
                                if let error = error {
                                    continuation.resume(throwing: error)
                                } else {
                                    continuation.resume(returning: ())
                                }
                            }
                        }
                        
                        let url = try await ref.downloadURL()
                        uploadedURLs.append(url.absoluteString)
                    } catch {
                        print("Upload error: \(error)")
                    }
                }
            }

            let dbRef = Database.database().reference().child("requests").childByAutoId()
            let requestId = dbRef.key ?? UUID().uuidString

            let requestData: [String: Any] = [
                "id": requestId,
                "title": title,
                "description": description,
                "phoneNumber": phone,
                "address": address,
                "location": [
                    "latitude": region.center.latitude,
                    "longitude": region.center.longitude
                ],
                "imageUrls": uploadedURLs,
                "createdBy": userId
            ]

            dbRef.setValue(requestData) { error, _ in
                self.isUploading = false
                completion(error == nil)
            }
        }
    }
}
