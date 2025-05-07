import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Privacy Policy")
                    .font(.system(size: 24, weight: .bold))
                
                Text("Effective Date: 21.04.2025.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Group {
                    Text("TourMate (the app) is committed to protecting your privacy. This Privacy Policy outlines how we collect, use, store, and share your information when you use the TourMate mobile application.")
                    
                    sectionTitle("1. Information We Collect")
                    
                    Text("""
We may collect the following types of personal and usage information:
 • Name and email address
 • Location data (to show relevant tours nearby)
 • Language preferences and selected categories
 • Usage activity (such as searches, favorites, and tour interactions)
""")
                    
                    sectionTitle("2. How We Use Your Information")
                    
                    Text("""
Your data is used for:
 • Providing and improving app functionality
 • Displaying personalized content and suggestions
 • Sending notifications and service-related messages (if permitted)
 • Analyzing user behavior to enhance the user experience
""")
                    
                    sectionTitle("3. Sharing with Third Parties")
                    
                    Text("""
We do not sell your personal data. Information may be shared with third parties only:
 • To comply with legal requirements
 • With service providers such as Firebase for hosting and analytics
""")
                    
                    sectionTitle("4. Security Measures")
                    
                    Text("""
We implement industry-standard practices to protect your data, including encryption and restricted access to our servers.
""")
                    
                    sectionTitle("5. Data Retention")
                    
                    Text("""
We retain your data as long as your account is active or as needed to provide services. You can request deletion at any time.
""")
                }
                .font(.body)
                .foregroundColor(.primary)
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .padding(.top, 8)
    }
}

#Preview {
    NavigationView {
        PrivacyPolicyView()
    }
}
