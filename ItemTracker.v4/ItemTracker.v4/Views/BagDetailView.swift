import SwiftUI

struct BagDetailView: View {
    @ObservedObject var bag: Bag
    @EnvironmentObject var bagsViewModel: BagsViewModel
    @State private var isShowingAddItemSheet = false
    @State private var newItemName = ""

    var body: some View {
        List {
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
        .navigationTitle(bag.name)
        .toolbar {
            Button(action: { isShowingAddItemSheet = true }) {
                Image(systemName: "plus")
            }
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