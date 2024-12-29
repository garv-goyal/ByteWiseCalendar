import SwiftUI

struct FoodItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String
    var date: Date
}
