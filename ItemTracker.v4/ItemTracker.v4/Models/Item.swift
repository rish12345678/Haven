import Foundation

class Item: Identifiable, Codable, ObservableObject {
    let id: UUID
    @Published var name: String
    @Published var isPacked: Bool

    enum CodingKeys: String, CodingKey {
        case id, name, isPacked
    }

    init(id: UUID = UUID(), name: String, isPacked: Bool = false) {
        self.id = id
        self.name = name
        self.isPacked = isPacked
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        isPacked = try container.decode(Bool.self, forKey: .isPacked)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(isPacked, forKey: .isPacked)
    }
} 