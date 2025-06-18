import SwiftUI
import FirebaseAuth

class SessionManager: ObservableObject {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    @Published var isAuthenticated: Bool = false

    func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            hasCompletedOnboarding = false
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    func checkAuth() {
        isAuthenticated = Auth.auth().currentUser != nil
    }
}
