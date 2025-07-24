import Foundation
import SwiftUI

struct Bag: Identifiable {
    let id = UUID()
    var name: String
    var items: [Item]
} 