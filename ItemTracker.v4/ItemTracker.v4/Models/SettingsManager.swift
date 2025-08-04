import Foundation

extension Notification.Name {
    static let geofenceRadiusChanged = Notification.Name("geofenceRadiusChanged")
}

class SettingsManager {
    static let shared = SettingsManager()
    private let geofenceRadiusKey = "GeofenceRadiusKey"

    private init() {}

    func saveGeofenceRadius(_ radius: Double) {
        UserDefaults.standard.set(radius, forKey: geofenceRadiusKey)
        NotificationCenter.default.post(name: .geofenceRadiusChanged, object: nil)
    }

    func loadGeofenceRadius() -> Double {
        let savedRadius = UserDefaults.standard.double(forKey: geofenceRadiusKey)
        return savedRadius == 0 ? 20.0 : savedRadius // Default to 20m if not set
    }
} 