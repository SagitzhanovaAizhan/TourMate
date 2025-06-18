import Foundation

struct ChatMessage: Identifiable, Codable {
    let id: UUID = UUID()
    let role: String
    let content: String

    private enum CodingKeys: String, CodingKey {
        case role, content
    }
}

struct DeepSeekRequest: Codable {
    let model: String
    let messages: [ChatMessage]
    let temperature: Double?
}

struct DeepSeekResponse: Codable {
    struct Choice: Codable {
        let message: ChatMessage
    }
    let choices: [Choice]
}
