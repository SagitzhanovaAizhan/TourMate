import SwiftUI
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var rememberMe = false
    @Published var isRegisterMode = false
    @Published var isLoading = false
    @Published var authErrorMessage: String?
    @Published var showAuthErrorAlert = false
    @Published var showSuccessAlert = false
    @Published var successMessage: String?

    func signIn() async throws {
        isLoading = true
        defer {
            isLoading = false
        }
        authErrorMessage = nil
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
            handleRememberMe()
        } catch {
            authErrorMessage = error.localizedDescription
            showAuthErrorAlert = true
        }
    }
    
    func register() async throws {
        guard password == confirmPassword else {
            authErrorMessage = "Passwords do not match."
            showAuthErrorAlert = true
            throw NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Passwords do not match."])
        }
        isLoading = true
        defer {
            isLoading = false
        }
        authErrorMessage = nil
        do {
            _ = try await Auth.auth().createUser(withEmail: email, password: password)
            handleRememberMe()
        } catch {
            authErrorMessage = error.localizedDescription
            showAuthErrorAlert = true
        }
    }
    
    func resetPassword() async {
        guard !email.isEmpty else {
            authErrorMessage = "Please enter your email first."
            showAuthErrorAlert = true
            return
        }
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            successMessage = "Password reset email sent!"
            showSuccessAlert = true
        } catch {
            authErrorMessage = error.localizedDescription
            showAuthErrorAlert = true
        }
    }
    
    private func handleRememberMe() {
        if rememberMe {
            UserDefaults.standard.set(email, forKey: "savedEmail")
        } else {
            UserDefaults.standard.removeObject(forKey: "savedEmail")
        }
    }
    
    func loadRememberedEmail() {
        if let savedEmail = UserDefaults.standard.string(forKey: "savedEmail") {
            email = savedEmail
            rememberMe = true
        }
    }
}
