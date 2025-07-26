import Foundation
import SwiftUI

class Bag: Identifiable, Codable, ObservableObject {
    @Published var name: String
    @Published var items: [Item]
    let id: UUID

    enum CodingKeys: String, CodingKey {
        case id, name, items
    }

    init(id: UUID = UUID(), name: String, items: [Item]) {
        self.id = id
        self.name = name
        self.items = items
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.items = try container.decode([Item].self, forKey: .items)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(items, forKey: .items)
    }
} 