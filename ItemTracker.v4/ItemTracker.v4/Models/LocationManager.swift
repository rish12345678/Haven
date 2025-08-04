import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus

    var monitoredRegions: Set<CLRegion> {
        return locationManager.monitoredRegions
    }

    override init() {
        self.authorizationStatus = locationManager.authorizationStatus
        super.init()
        self.locationManager.delegate = self
    }

    func requestLocationPermission() {
        locationManager.requestAlwaysAuthorization()
    }

    func startMonitoring(for bag: Bag) {
        guard let lat = bag.latitude, let lon = bag.longitude else { return }
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let radius = SettingsManager.shared.loadGeofenceRadius()
        let region = CLCircularRegion(center: center, radius: radius, identifier: bag.id.uuidString)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        locationManager.startMonitoring(for: region)
        print("Started monitoring region for bag: \(bag.name)")
    }

    func stopMonitoring(for bag: Bag) {
        for region in locationManager.monitoredRegions {
            if region.identifier == bag.id.uuidString {
                locationManager.stopMonitoring(for: region)
                print("Stopped monitoring region for bag: \(bag.name)")
            }
        }
    }

    func stopMonitoring(for region: CLRegion) {
        locationManager.stopMonitoring(for: region)
        print("Stopped monitoring region: \(region.identifier)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered region: \(region.identifier)")
        let bagName = getBagName(from: region.identifier) ?? "your bag"
        let userInfo = ["bagID": region.identifier]
        NotificationManager.shared.scheduleNotification(
            title: "Welcome!",
            body: "You've arrived at the location for \(bagName).",
            userInfo: userInfo
        )
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited region: \(region.identifier)")
        let bagName = getBagName(from: region.identifier) ?? "your bag"
        let userInfo = ["bagID": region.identifier]
        NotificationManager.shared.scheduleNotification(
            title: "Don't Forget Your Bag!",
            body: "Did you remember everything in \(bagName)?",
            userInfo: userInfo
        )
    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region: \(region?.identifier ?? "unknown") with error: \(error.localizedDescription)")
    }
    
    private func getBagName(from identifier: String) -> String? {
        let bags = DataManager.shared.loadBags()
        return bags.first(where: { $0.id.uuidString == identifier })?.name
    }
} 