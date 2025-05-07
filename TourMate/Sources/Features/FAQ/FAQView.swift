import SwiftUI

struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

struct FAQView: View {
    @State private var expandedIndex: UUID?

    let items: [FAQItem] = [
        FAQItem(question: "What is TourMate?",
                answer: "TourMate is a mobile application designed for tourists in Kazakhstan. It helps users find tours, local attractions, create requests, and connect with other travelers."),
        FAQItem(question: "Do I need to register to use the app?",
                answer: "Yes, registration is required to access features like chat, tour creation, and saving favorites."),
        FAQItem(question: "Does the app track my location?",
                answer: "Only with your permission. Location data helps us recommend nearby places and tours more accurately."),
        FAQItem(question: "Can I create my own tours or announcements?",
                answer: "Yes! TourMate allows users to create custom tour posts and community requests."),
        FAQItem(question: "Can I use TourMate offline?",
                answer: "While most features require an internet connection, some previously loaded data like saved tours or favorite locations may be accessible offline. However, real-time search, chat, and posting announcements need an active connection."),
        FAQItem(question: "How can I delete my account?",
                answer: "Go to My Profile → Settings → Delete Account, or email us at support@tourmate.kz."),
        FAQItem(question: "I found a bug. How can I report it?",
                answer: "Please send a detailed report to bugs@tourmate.kz, or use the built-in feedback form.")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Frequently Asked Questions")
                    .font(.custom(AppFont.bold, size: 24))
                    .padding(.bottom, 4)

                ForEach(items) { item in
                    VStack(alignment: .leading, spacing: 8) {
                        Button(action: {
                            withAnimation {
                                expandedIndex = (expandedIndex == item.id) ? nil : item.id
                            }
                        }) {
                            HStack {
                                Text(item.question)
                                    .font(.custom(AppFont.regular, size: 16))
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: expandedIndex == item.id ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }

                        if expandedIndex == item.id {
                            Text(item.answer)
                                .font(.custom(AppFont.regular, size: 14))
                                .foregroundColor(.black)
                                .padding(.horizontal, 12)
                                .transition(.opacity)
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .navigationTitle("FAQ")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        FAQView()
    }
}
