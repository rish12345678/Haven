import SwiftUI

struct BagDetailView: View {
    @ObservedObject var bag: Bag
    @EnvironmentObject var bagsViewModel: BagsViewModel
    @StateObject private var locationManager = LocationManager()
    @State private var isShowingAddItemSheet = false
    @State private var isShowingMapView = false
    @State private var showLocationDeniedAlert = false
    @State private var newItemName = ""

    var body: some View {
        List {
            Section(header: Text("Location")) {
                if let locationName = bag.locationName {
                    Text(locationName)
                }
                Button(action: {
                    checkLocationPermission()
                }) {
                    Text(bag.locationName == nil ? "Set Location" : "Change Location")
                }
            }

            Section(header: Text("Items")) {
                ForEach(bag.items) { item in
                    HStack {
                        Button(action: {
                            item.isPacked.toggle()
                            bagsViewModel.save()
                        }) {
                            Image(systemName: item.isPacked ? "checkmark.circle.fill" : "circle")
                        }
                        Text(item.name)
                    }
                }
                .onDelete(perform: deleteItem)
            }
        }
        .navigationTitle(bag.name)
        .toolbar {
            Button(action: { isShowingAddItemSheet = true }) {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $isShowingMapView, onDismiss: {
            bagsViewModel.save()
            NotificationManager.shared.requestPermission()
        }) {
            MapView(latitude: $bag.latitude, longitude: $bag.longitude, locationName: $bag.locationName)
        }
        .sheet(isPresented: $isShowingAddItemSheet) {
            NavigationView {
                Form {
                    TextField("Item Name", text: $newItemName)
                }
                .navigationTitle("New Item")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            isShowingAddItemSheet = false
                            newItemName = ""
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            if !newItemName.isEmpty {
                                addItem(name: newItemName)
                                isShowingAddItemSheet = false
                                newItemName = ""
                            }
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showLocationDeniedAlert) {
            Alert(
                title: Text("Location Access Denied"),
                message: Text("Please enable location services in Settings to use this feature."),
                primaryButton: .default(Text("Settings"), action: {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }),
                secondaryButton: .cancel()
            )
        }
    }

    private func checkLocationPermission() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestLocationPermission()
        case .authorizedWhenInUse, .authorizedAlways:
            isShowingMapView = true
        case .denied, .restricted:
            showLocationDeniedAlert = true
        @unknown default:
            break
        }
    }

    private func addItem(name: String) {
        let newItem = Item(name: name)
        bag.items.append(newItem)
        bagsViewModel.save()
    }

    private func deleteItem(at offsets: IndexSet) {
        bag.items.remove(atOffsets: offsets)
        bagsViewModel.save()
    }
} 
