import Foundation

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = [
        .init(role: "system", content: "You are a helpful assistant.")
    ]
    @Published var inputText = ""
    @Published var isLoading = false

    private let apiKey = "sk-d9c08dfb39bd41d599bc3da0b94e4707"
    private let endpoint = "https://api.deepseek.com/v1/chat/completions"

    func sendMessage() async {
        let userMessage = ChatMessage(role: "user", content: inputText)
        messages.append(userMessage)
        inputText = ""
        isLoading = true

        let requestBody = DeepSeekRequest(model: "deepseek-chat", messages: messages, temperature: 0.7)

        do {
            var request = URLRequest(url: URL(string: endpoint)!)
            request.httpMethod = "POST"
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(requestBody)

            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(DeepSeekResponse.self, from: data)

            if let reply = response.choices.first?.message {
                messages.append(reply)
            }
        } catch {
            messages.append(.init(role: "assistant", content: "❌ Error: \(error.localizedDescription)"))
        }

        isLoading = false
    }
}
