import SwiftUI
import FirebaseAuth
import FirebaseDatabase

@MainActor
class RequestDetailViewModel: ObservableObject {
    @Published var isLiked = false

    private var userId: String? {
        Auth.auth().currentUser?.uid
    }

    func loadLikeStatus(for requestId: String) {
        guard let userId else { return }
        let ref = Database.database().reference().child("likes").child(userId).child(requestId)
        ref.observeSingleEvent(of: .value) { snapshot in
            self.isLiked = snapshot.exists()
        }
    }

    func toggleLike(for requestId: String) {
        guard let userId else { return }
        let ref = Database.database().reference().child("likes").child(userId).child(requestId)

        if isLiked {
            ref.removeValue()
            isLiked = false
        } else {
            ref.setValue(true)
            isLiked = true
        }
    }
}
