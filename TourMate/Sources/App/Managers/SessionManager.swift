import SwiftUI
import FirebaseAuth

class SessionManager: ObservableObject {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    @Published var isAuthenticated: Bool = Auth.auth().currentUser != nil

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
