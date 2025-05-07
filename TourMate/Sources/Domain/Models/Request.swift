import Foundation

struct Request: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let category: String
    let phoneNumber: String
    let address: String
    let location: Location
    let imageUrls: [String]
    let createdBy: String?

    struct Location: Codable {
        let latitude: Double
        let longitude: Double
    }
}
