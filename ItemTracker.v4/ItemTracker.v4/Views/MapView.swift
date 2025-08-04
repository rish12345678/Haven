import SwiftUI
import MapKit

struct IdentifiablePointAnnotation: Identifiable {
    let id = UUID()
    var annotation: MKPointAnnotation
}

struct MapView: View {
    @Binding var latitude: Double?
    @Binding var longitude: Double?
    @Binding var locationName: String?
    @Environment(\.presentationMode) var presentationMode
    @State private var region: MKCoordinateRegion
    @State private var annotation: IdentifiablePointAnnotation?
    @StateObject private var locationSearchService = LocationSearchService()
    @State private var searchQuery = ""

    init(latitude: Binding<Double?>, longitude: Binding<Double?>, locationName: Binding<String?>) {
        self._latitude = latitude
        self._longitude = longitude
        self._locationName = locationName
        
        let initialCenter = CLLocationCoordinate2D(
            latitude: latitude.wrappedValue ?? 37.7749,
            longitude: longitude.wrappedValue ?? -122.4194
        )
        _region = State(initialValue: MKCoordinateRegion(
            center: initialCenter,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
        
        if let lat = latitude.wrappedValue, let lon = longitude.wrappedValue {
            let point = MKPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            point.title = locationName.wrappedValue
            _annotation = State(initialValue: IdentifiablePointAnnotation(annotation: point))
        } else {
            _annotation = State(initialValue: nil)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search for a location", text: $searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: searchQuery) {
                        locationSearchService.search(query: searchQuery)
                    }

                if !locationSearchService.completions.isEmpty {
                    List(locationSearchService.completions, id: \.self) { completion in
                        Button(action: {
                            selectSearchCompletion(completion)
                        }) {
                            Text(completion.title)
                        }
                    }
                    .frame(height: 200)
                }
                
                Map(initialPosition: .region(region)) {
                    if let annotation = annotation {
                        Marker(annotation.annotation.title ?? "", coordinate: annotation.annotation.coordinate)
                    }
                }
                .onTapGesture {
//                    Something happens
                }
            }
            .navigationTitle("Set Location")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveLocation()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    private func selectSearchCompletion(_ completion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response else {
                print("Error getting search response: \(error?.localizedDescription ?? "unknown error")")
                return
            }

            if let mapItem = response.mapItems.first {
                let coordinate = mapItem.placemark.coordinate
                self.region.center = coordinate
                
                let point = MKPointAnnotation()
                point.coordinate = coordinate
                point.title = mapItem.name
                self.annotation = IdentifiablePointAnnotation(annotation: point)

                self.searchQuery = mapItem.name ?? ""
                self.locationSearchService.completions = []
            }
        }
    }

    private func saveLocation() {
        if let annotation = annotation {
            latitude = annotation.annotation.coordinate.latitude
            longitude = annotation.annotation.coordinate.longitude
            locationName = annotation.annotation.title
        }
    }
}

class LocationSearchService: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var completions: [MKLocalSearchCompletion] = []
    private var completer: MKLocalSearchCompleter

    override init() {
        self.completer = MKLocalSearchCompleter()
        super.init()
        self.completer.delegate = self
    }

    func search(query: String) {
        completer.queryFragment = query
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.completions = completer.results
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error getting search completions: \(error.localizedDescription)")
    }
} 
