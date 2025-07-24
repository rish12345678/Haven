//
//  ContentView.swift
//  ItemTracker.v4
//
//  Created by Rishab on 7/23/25.
//

import SwiftUI

struct ContentView: View {
    @State private var bags: [Bag] = [
        Bag(name: "Gym Bag"),
        Bag(name: "Work Backpack"),
        Bag(name: "Hiking Pack")
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(bags) { bag in
                    Text(bag.name)
                }
            }
            .navigationTitle("Baggage Claim")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addBag) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    private func addBag() {
        bags.append(Bag(name: "New Bag"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
