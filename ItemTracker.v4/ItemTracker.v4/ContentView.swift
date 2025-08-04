//
//  ContentView.swift
//  ItemTracker.v4
//
//  Created by Rishab on 7/23/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            BagsView()
                .tabItem {
                    Label("Bags", systemImage: "bag.fill")
                }
            
            LocationPermissionView()
                .tabItem {
                    Label("Location", systemImage: "location.fill")
                }
            
            NotificationPermissionView()
                .tabItem {
                    Label("Notifications", systemImage: "bell.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
