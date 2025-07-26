import SwiftUI

struct BagsView: View {
    @StateObject private var bags = BagsViewModel()
    @State private var isShowingAddBagSheet = false
    @State private var newBagName = ""

    var body: some View {
        NavigationView {
            Group {
                if bags.bags.isEmpty {
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
                } else {
                    List {
                        ForEach(bags.bags) { bag in
                            NavigationLink(destination: BagDetailView(bag: bag).environmentObject(bags)) {
                                Text(bag.name)
                            }
                        }
                        .onDelete(perform: deleteBag)
                    }
                }
            }
            .navigationTitle("Your Bags")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isShowingAddBagSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddBagSheet) {
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
            .environmentObject(bags)
        }
    }

    private func addBag(name: String) {
        bags.addBag(name: name)
    }

    private func deleteBag(at offsets: IndexSet) {
        bags.deleteBag(at: offsets)
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
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region as! CLCircularRegion)
        }
        startMonitoringAllBags()
    }
}

struct BagsView_Previews: PreviewProvider {
    static var previews: some View {
        BagsView()
    }
} 