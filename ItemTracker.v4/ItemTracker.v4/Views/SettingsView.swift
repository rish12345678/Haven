import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Text("Settings will go here.")
                .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
} 