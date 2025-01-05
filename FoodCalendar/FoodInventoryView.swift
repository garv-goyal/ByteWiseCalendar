import SwiftUI

struct FoodInventoryView: View {
    @Binding var foodItems: [FoodItem]
    @Binding var isDarkMode: Bool
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sortedFoodItems(), id: \.id) { item in
                    InventoryRow(foodItem: item, isDarkMode: isDarkMode)
                }
            }
            .navigationTitle("Food Inventory")
            .background(isDarkMode ? Color.black.opacity(0.05) : Color.white)
        }
        .accentColor(.purple)
    }
    
    // Sort food items by expiration date
    func sortedFoodItems() -> [FoodItem] {
        foodItems.sorted { $0.date < $1.date }
    }
}

struct InventoryRow: View {
    let foodItem: FoodItem
    var isDarkMode: Bool
    
    var body: some View {
        HStack {
            Image(foodItem.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .shadow(radius: 2)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(foodItem.name)
                    .font(.headline)
                    .foregroundColor(isDarkMode ? .white : .black)
                Text("Expires on \(formattedDate(foodItem.date))")
                    .font(.subheadline)
                    .foregroundColor(isDarkMode ? .gray : .secondary)
            }
            .padding(.leading, 5)
            
            Spacer()
            
            // Highlight items expiring soon
            if isExpiringSoon(date: foodItem.date) {
                Text("⏰")
            }
        }
        .padding(.vertical, 5)
        .background(isDarkMode ? Color(UIColor.systemGray6) : Color(UIColor.systemGray5))
        .cornerRadius(10)
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func isExpiringSoon(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(date) || calendar.isDateInTomorrow(date)
    }
}
