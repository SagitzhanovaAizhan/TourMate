import SwiftUI
import FirebaseAuth

@MainActor
class ProfileEditViewModel: ObservableObject {
    @Published var displayName: String = ""
    @Published var photoURL: String = ""
    @Published var email: String = ""
    @Published var isSaving = false
    @Published var errorMessage: String?

    func loadUserInfo() {
        guard let user = Auth.auth().currentUser else { return }
        displayName = user.displayName ?? ""
        photoURL = user.photoURL?.absoluteString ?? ""
        email = user.email ?? ""
    }

    func saveChanges(dismiss: @escaping () -> Void) {
        guard let user = Auth.auth().currentUser else { return }

        isSaving = true
        errorMessage = nil

        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        if let url = URL(string: photoURL) {
            changeRequest.photoURL = url
        }

        changeRequest.commitChanges { [weak self] error in
            guard let self else { return }
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.isSaving = false
                return
            }

            // Обновить email отдельно
            if user.email != email {
                user.updateEmail(to: email) { error in
                    Task { @MainActor in
                        self.isSaving = false
                        if let error = error {
                            self.errorMessage = error.localizedDescription
                        } else {
                            dismiss()
                        }
                    }
                }
            } else {
                self.isSaving = false
                dismiss()
            }
        }
    }
}
