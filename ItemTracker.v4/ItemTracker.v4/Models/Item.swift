import Foundation

struct Item: Identifiable, Codable {
    let id = UUID()
    var name: String
    var isPacked: Bool = false
} 