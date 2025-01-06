import SwiftUI

struct FoodInventoryView: View {
    @Binding var foodItems: [FoodItem]
    @Binding var isDarkMode: Bool
    
    init(foodItems: Binding<[FoodItem]>, isDarkMode: Binding<Bool>) {
        self._foodItems = foodItems
        self._isDarkMode = isDarkMode
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemPurple
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 34)
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: isDarkMode
                                       ? [Color.purple.opacity(0.5), Color.blue.opacity(0.3)]
                                       : [Color.purple.opacity(0.1), Color.purple.opacity(0.0)]
                                      ),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: 775, height: 200)
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding()
                .padding([.leading, .bottom], 16)
                
                VStack(alignment: .center, spacing: 10) {
                    Image(systemName: "calendar.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(isDarkMode ? Color.purple : Color.purple.opacity(1.5))
                        .shadow(radius: 5)
                        .padding(.trailing, -50)
                    
                    Text("Food Inventory")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(isDarkMode ? Color.white : Color.black)
                        .padding(.trailing, -50)
                    
                    Text("Manage your food items and reduce waste effortlessly.")
                        .font(.subheadline)
                        .foregroundColor(isDarkMode ? Color.white.opacity(0.7) : Color.black.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.leading, 16)
                        .padding(.trailing, -35)
                }
                .padding(.bottom, 30)
                .padding(.trailing, 30)
            }
            .padding(.top, 5)
            .padding(.bottom, -15)
            .padding(.trailing, 15)
            
            Divider()
            
            HStack {
                Spacer()
                EditButton()
                    .foregroundColor(.purple)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 5)
            .padding(.trailing, 20)
            .background(isDarkMode ? Color.black.edgesIgnoringSafeArea(.all) : Color.white.edgesIgnoringSafeArea(.all))
            
            List {
                ForEach(sortedFoodItems(), id: \.id) { item in
                    InventoryRow(foodItem: item, isDarkMode: isDarkMode)
                }
                .onDelete(perform: deleteItems)
            }
            .listStyle(InsetGroupedListStyle())
            .background(isDarkMode ? Color.black.opacity(0.05) : Color.white)
            .accentColor(.purple)
        }
        .background(isDarkMode ? Color.black.edgesIgnoringSafeArea(.all) : Color.purple.opacity(0.0).edgesIgnoringSafeArea(.all))
        .navigationTitle("Food Inventory")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func sortedFoodItems() -> [FoodItem] {
        foodItems.sorted { $0.date < $1.date }
    }
    
    func deleteItems(at offsets: IndexSet) {
        let sortedItems = sortedFoodItems()
        for index in offsets {
            let itemToDelete = sortedItems[index]
            if let originalIndex = foodItems.firstIndex(where: { $0.id == itemToDelete.id }) {
                foodItems.remove(at: originalIndex)
            }
        }
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
                .accessibilityHidden(true)
            

            VStack(alignment: .leading, spacing: 5) {
                Text(foodItem.name)
                    .font(.headline)
                    .foregroundColor(isDarkMode ? .white : .black)
                
                Text("Expires on \(formattedDate(foodItem.date))")
                    .font(.subheadline)
                    .foregroundColor(isDarkMode ? .gray.opacity(0.7) : .secondary)
            }
            .padding(.leading, 5)
            
            Spacer()

            if isExpiringSoon(date: foodItem.date) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                    .accessibilityLabel("Expiring Soon")
            }
        }
        .padding(.vertical, 5)
        .background(isDarkMode ? Color(.systemGray6) : Color(.systemGray5))
        .cornerRadius(10)
        .shadow(color: isDarkMode ? Color.black.opacity(0.1) : Color.gray.opacity(0.1), radius: 2, x: 0, y: 2)
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func isExpiringSoon(date: Date) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        let startOfDate = calendar.startOfDay(for: date)
        guard let twoDaysFromNow = calendar.date(byAdding: .day, value: 2, to: startOfToday) else { return false }
        return startOfDate <= twoDaysFromNow && startOfDate >= startOfToday
    }
}
