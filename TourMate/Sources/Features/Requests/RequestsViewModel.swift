import SwiftUI
import FirebaseAuth
import FirebaseDatabase

@MainActor
class RequestsViewModel: ObservableObject {
    enum ViewState: String {
        case saved
        case requests
        case tours
        
        var title: String {
            switch self {
            case .saved:
                return "Saved"
            case .requests:
                return "My requests"
            case .tours:
                return "My tours"
            }
        }
    }

    @Published var allRequests: [Request] = []
    @Published var likedIDs: Set<String> = []

    var userId: String? {
        Auth.auth().currentUser?.uid
    }

    func loadRequests() {
        let ref = Database.database().reference().child("requests")
        ref.observeSingleEvent(of: .value) { snapshot in
            var temp: [Request] = []
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let data = try? JSONSerialization.data(withJSONObject: snap.value ?? [:]),
                   let request = try? JSONDecoder().decode(Request.self, from: data) {
                    temp.append(request)
                }
            }
            DispatchQueue.main.async {
                self.allRequests = temp
            }
        }
    }

    func loadLiked() {
        guard let userId else { return }
        let ref = Database.database().reference().child("likes").child(userId)
        ref.observeSingleEvent(of: .value) { snapshot in
            var ids = Set<String>()
            for child in snapshot.children {
                if let snap = child as? DataSnapshot {
                    ids.insert(snap.key)
                }
            }
            DispatchQueue.main.async {
                self.likedIDs = ids
            }
        }
    }

    func toggleLike(for id: String) {
        guard let userId else { return }
        let ref = Database.database().reference().child("likes").child(userId).child(id)
        if likedIDs.contains(id) {
            ref.removeValue()
            likedIDs.remove(id)
        } else {
            ref.setValue(true)
            likedIDs.insert(id)
        }
    }

    func filteredRequests(for state: ViewState) -> [Request] {
        switch state {
        case .saved:
            return allRequests.filter { likedIDs.contains($0.id) }
        case .requests:
            guard let userId else { return [] }
            return allRequests.filter {
                $0.category == "Request" && $0.createdBy == userId
            }
        case .tours:
            guard let userId else { return [] }
            return allRequests.filter {
                $0.category == "Tour" && $0.createdBy == userId
            }
        }
    }
    
    func deleteRequest(id: String) {
        let ref = Database.database().reference().child("requests").child(id)
        ref.removeValue { error, _ in
            if error == nil {
                DispatchQueue.main.async {
                    self.allRequests.removeAll { $0.id == id }
                }
            }
        }
    }
}
