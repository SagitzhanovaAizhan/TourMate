import Foundation
import FirebaseAuth

class SessionManager: ObservableObject {
    @Published var isAuthenticated: Bool = Auth.auth().currentUser != nil

    func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    func checkAuth() {
        isAuthenticated = Auth.auth().currentUser != nil
    }
}
