import SwiftUI

struct BagsView: View {
    @State private var bags: [Bag] = [
        Bag(name: "Gym Bag", items: [Item(name: "Water Bottle"), Item(name: "Towel")]),
        Bag(name: "Work Backpack", items: [Item(name: "Laptop"), Item(name: "Charger"), Item(name: "Notebook")]),
        Bag(name: "Hiking Pack", items: [Item(name: "Snacks"), Item(name: "Sunscreen"), Item(name: "First-Aid Kit")])
    ]
    @State private var isShowingAddBagSheet = false
    @State private var newBagName = ""

    var body: some View {
        NavigationView {
            List {
                ForEach($bags) { $bag in
                    NavigationLink(destination: BagDetailView(bag: $bag)) {
                        Text(bag.name)
                    }
                }
                .onDelete(perform: deleteBag)
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
                                    addBag(name: newBagName)
                                    isShowingAddBagSheet = false
                                    newBagName = ""
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private func addBag(name: String) {
        let newBag = Bag(name: name, items: [])
        bags.append(newBag)
    }

    private func deleteBag(at offsets: IndexSet) {
        bags.remove(atOffsets: offsets)
    }
}

struct BagsView_Previews: PreviewProvider {
    static var previews: some View {
        BagsView()
    }
} 