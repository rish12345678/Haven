import SwiftUI
import CoreLocation

struct LocationPermissionView: View {
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        VStack {
            switch locationManager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                Text("Location access granted!")
                    .font(.largeTitle)
                    .foregroundColor(.green)
            case .denied, .restricted:
                VStack(spacing: 20) {
                    Text("Location Access Denied")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Text("Please enable location services in Settings to use this feature.")
                        .multilineTextAlignment(.center)
                        .padding()
                    Button("Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            case .notDetermined:
                VStack(spacing: 20) {
                    Text("Location Access Required")
                        .font(.largeTitle)
                    Text("This app needs your location to provide location-based features. Please grant 'Always' access for the best experience.")
                        .multilineTextAlignment(.center)
                        .padding()
                    Button("Request Permission") {
                        locationManager.requestLocationPermission()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            @unknown default:
                Text("Unknown authorization status")
            }
        }
    }
}

struct LocationPermissionView_Previews: PreviewProvider {
    static var previews: some View {
        LocationPermissionView()
    }
} 