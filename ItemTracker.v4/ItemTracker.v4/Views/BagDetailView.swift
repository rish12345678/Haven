import SwiftUI

struct BagDetailView: View {
    @Binding var bag: Bag
    @State private var newItemName = ""

    var body: some View {
        List {
            ForEach($bag.items) { $item in
                HStack {
                    Text(item.name)
                    Spacer()
                    // We will add a toggle here later for packing status
                }
            }
            .onDelete(perform: deleteItem)

            HStack {
                TextField("New Item", text: $newItemName)
                Button(action: addItem) {
                    Image(systemName: "plus.circle.fill")
                }
                .disabled(newItemName.isEmpty)
            }
        }
        .navigationTitle(bag.name)
    }

    private func addItem() {
        guard !newItemName.isEmpty else { return }
        let newItem = Item(name: newItemName)
        bag.items.append(newItem)
        newItemName = ""
    }

    private func deleteItem(at offsets: IndexSet) {
        bag.items.remove(atOffsets: offsets)
    }
} 