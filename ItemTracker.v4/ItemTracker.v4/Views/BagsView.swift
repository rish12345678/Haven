import SwiftUI
import CoreLocation

struct BagsView: View {
    @StateObject private var bags = BagsViewModel()
    @State private var isShowingAddBagSheet = false
    @State private var newBagName = ""
    @State private var activeBag: Bag?

    var body: some View {
        NavigationView {
            content
                .navigationTitle("Your Bags")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { isShowingAddBagSheet = true }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $isShowingAddBagSheet) {
                    addBagSheet
                }
                .environmentObject(bags)
                .onAppear(perform: setupDeepLinkObserver)
        }
    }

    @ViewBuilder
    private var content: some View {
        if bags.bags.isEmpty {
            emptyView
        } else {
            bagsListView
        }
    }

    private var emptyView: some View {
        VStack {
            Text("No bags yet!")
                .font(.title)
            Button(action: { isShowingAddBagSheet = true }) {
                Text("Add your first bag")
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }

    private var bagsListView: some View {
        List {
            ForEach(bags.bags) { bag in
                NavigationLink(destination: BagDetailView(bag: bag).environmentObject(bags), tag: bag, selection: $activeBag) {
                    Text(bag.name)
                }
            }
            .onDelete(perform: deleteBag)
        }
    }

    private func deleteBag(at offsets: IndexSet) {
        bags.deleteBag(at: offsets)
    }

    private var addBagSheet: some View {
        NavigationView {
            Form {
                TextField("Bag Name", text: $newBagName)
            }
            .navigationTitle("New Bag")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isShowingAddBagSheet = false
                        newBagName = ""
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if !newBagName.isEmpty {
                            bags.addBag(name: newBagName)
                            isShowingAddBagSheet = false
                            newBagName = ""
                        }
                    }
                }
            }
        }
    }

    private func setupDeepLinkObserver() {
        NotificationCenter.default.addObserver(forName: .deepLinkToBag, object: nil, queue: .main) { notification in
            if let userInfo = notification.userInfo, let bagIDString = userInfo["bagID"] as? String {
                self.activeBag = self.bags.bags.first(where: { $0.id.uuidString == bagIDString })
            }
        }
    }

    private func addBag(name: String) {
        bags.addBag(name: name)
    }
}

class BagsViewModel: ObservableObject {
    @Published var bags: [Bag]
    private let locationManager = LocationManager()

    init() {
        self.bags = DataManager.shared.loadBags()
        startMonitoringAllBags()
    }

    func save() {
        DataManager.shared.save(bags: bags)
        updateAllMonitoredRegions()
    }

    func addBag(name: String) {
        let newBag = Bag(name: name, items: [])
        bags.append(newBag)
        save()
    }

    func deleteBag(at offsets: IndexSet) {
        let bagsToRemove = offsets.map { self.bags[$0] }
        for bag in bagsToRemove {
            locationManager.stopMonitoring(for: bag)
        }
        bags.remove(atOffsets: offsets)
        save()
    }

    private func startMonitoringAllBags() {
        for bag in bags {
            locationManager.startMonitoring(for: bag)
        }
    }

    private func updateAllMonitoredRegions() {
        let currentRegions = locationManager.monitoredRegions
        for region in currentRegions {
            locationManager.stopMonitoring(for: region)
        }
        startMonitoringAllBags()
    }
}

struct BagsView_Previews: PreviewProvider {
    static var previews: some View {
        BagsView()
    }
} 
