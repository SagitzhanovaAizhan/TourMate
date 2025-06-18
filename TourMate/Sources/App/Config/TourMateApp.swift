import SwiftUI
import FirebaseAuth

@main
struct TourMateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    @StateObject private var sessionManager = SessionManager()
    @State private var isCheckingAuthStatus = true
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            Group {
                if showSplash {
                    SplashscreenView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    showSplash = false
                                    sessionManager.checkAuth()
                                    isCheckingAuthStatus = false
                                }
                            }
                        }
                } else if isCheckingAuthStatus {
                    ProgressView()
                } else if !hasCompletedOnboarding {
                    OnboardingView {
                        hasCompletedOnboarding = true
                    }
                } else if !sessionManager.isAuthenticated {
                    AuthView {
                        sessionManager.isAuthenticated = true
                    }
                    .environmentObject(sessionManager)
                } else {
                    MainView()
                        .environmentObject(sessionManager)
                }
            }
        }
    }
}
