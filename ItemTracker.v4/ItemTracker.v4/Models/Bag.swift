import Foundation
import SwiftUI

class Bag: Identifiable, Codable, ObservableObject {
    @Published var name: String
    @Published var items: [Item]
    @Published var locationName: String?
    @Published var latitude: Double?
    @Published var longitude: Double?
    let id: UUID

    enum CodingKeys: String, CodingKey {
        case id, name, items, locationName, latitude, longitude
    }

    init(id: UUID = UUID(), name: String, items: [Item], locationName: String? = nil, latitude: Double? = nil, longitude: Double? = nil) {
        self.id = id
        self.name = name
        self.items = items
        self.locationName = locationName
        self.latitude = latitude
        self.longitude = longitude
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.items = try container.decode([Item].self, forKey: .items)
        self.locationName = try container.decodeIfPresent(String.self, forKey: .locationName)
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(items, forKey: .items)
        try container.encodeIfPresent(locationName, forKey: .locationName)
        try container.encodeIfPresent(latitude, forKey: .latitude)
        try container.encodeIfPresent(longitude, forKey: .longitude)
    }
} 