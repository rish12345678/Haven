import Foundation

class DataManager {
    static let shared = DataManager()
    private let bagsKey = "BagsKey"

    func save(bags: [Bag]) {
        do {
            let data = try JSONEncoder().encode(bags)
            UserDefaults.standard.set(data, forKey: bagsKey)
            print("Bags saved successfully.")
        } catch {
            print("Failed to save bags: \(error)")
        }
    }

    func loadBags() -> [Bag] {
        guard let data = UserDefaults.standard.data(forKey: bagsKey) else {
            print("No saved bags found. Starting with an empty list.")
            return []
        }
        do {
            let bags = try JSONDecoder().decode([Bag].self, from: data)
            print("Bags loaded successfully.")
            return bags
        } catch {
            print("Failed to load bags: \(error)")
            return []
        }
    }
} 