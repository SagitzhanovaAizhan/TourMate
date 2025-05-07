import SwiftUI
import PhotosUI
import FirebaseAuth

@MainActor
class ProfileEditViewModel: ObservableObject {
    @Published var displayName: String = ""
    @Published var photoURL: URL?
    @Published var selectedPhoto: PhotosPickerItem?
    @Published var selectedImage: UIImage?
    @Published var email: String = ""
    @Published var isSaving = false
    @Published var errorMessage: String?
    
    private var selectedPhotoUrl: URL?
    
    func handlePhotoSelection() async {
        if let data = try? await selectedPhoto?.loadTransferable(type: Data.self),
           let uiImage = UIImage(data: data) {
            selectedImage = uiImage
        }
    }
    
    func loadUserInfo() {
        guard let user = Auth.auth().currentUser else { return }
        displayName = user.displayName ?? ""
        photoURL = user.photoURL
        email = user.email ?? ""
    }
    
    func saveChanges(dismiss: @escaping () -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        isSaving = true
        errorMessage = nil
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        Task { @MainActor in
            do {
                if let selectedImage {
                    photoURL = try await ImageStorageManager.uploadAsJPEG(image: selectedImage,
                                                                          path: "profilePicture/",
                                                                          compressionQuality: 0.5)
                }
                if let url = photoURL {
                    changeRequest.photoURL = url
                }
                try await changeRequest.commitChanges()
                if user.email != email {
                    try await user.sendEmailVerification(beforeUpdatingEmail: self.email)
                }
                self.isSaving = false
                dismiss()
            } catch {
                self.errorMessage = error.localizedDescription
                self.isSaving = false
            }
        }
    }
}
