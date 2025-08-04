import SwiftUI

struct SettingsView: View {
    @State private var geofenceRadius: Double = SettingsManager.shared.loadGeofenceRadius()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Geofence Settings")) {
                    VStack(alignment: .leading) {
                        Text("Radius: \(Int(geofenceRadius)) meters")
                        Slider(
                            value: $geofenceRadius,
                            in: 20...100,
                            step: 5,
                            onEditingChanged: { editing in
                                if !editing {
                                    SettingsManager.shared.saveGeofenceRadius(geofenceRadius)
                                }
                            }
                        )
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
} 