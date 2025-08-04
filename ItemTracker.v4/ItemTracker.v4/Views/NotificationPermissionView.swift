import SwiftUI

struct NotificationPermissionView: View {
    @StateObject private var notificationManager = NotificationManager.shared

    var body: some View {
        VStack(spacing: 20) {
            if notificationManager.hasPermission {
                Text("Notification permission granted!")
                    .font(.largeTitle)
                    .foregroundColor(.green)
            } else {
                Text("Enable Notifications")
                    .font(.largeTitle)
                Text("Please enable notifications to receive alerts when you leave a bag behind.")
                    .multilineTextAlignment(.center)
                    .padding()
                Button("Enable Notifications") {
                    notificationManager.requestPermission()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
    }
}

struct NotificationPermissionView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationPermissionView()
    }
} 