import SwiftUI

struct StatisticsView: View {
    @Binding var foodItems: [FoodItem]
    @Binding var isDarkMode: Bool
    @State private var lastWeekSavings: Double = 15.30
    @State private var thisWeekSavings: Double = 5.45
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Total Items
                    StatisticCard(title: "Total Items", value: String(foodItems.count), icon: "cart.fill", isDarkMode: isDarkMode)
                    
                    // Items Expiring Soon
                    let expiringSoonCount = foodItems.filter { isExpiringSoon(date: $0.date) }.count
                    StatisticCard(title: "Expiring Soon", value: String(expiringSoonCount), icon: "timer", isDarkMode: isDarkMode)
                    
                    // Weekly Savings
                    StatisticCard(title: "Weekly Savings", value: "$\(calculateWeeklySavings())", icon: "dollarsign.circle.fill", isDarkMode: isDarkMode)
                    
                    // Add more statistics as needed
                }
                .padding()
            }
            .navigationTitle("Statistics")
            .background(isDarkMode ? Color.black.opacity(0.05) : Color.white)
        }
        .accentColor(.purple)
    }
    
    // Helper to check if a date is today or tomorrow
    func isExpiringSoon(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(date) || calendar.isDateInTomorrow(date)
    }
    
    // Example calculation for weekly savings
    func calculateWeeklySavings() -> String {
        // Replace with actual calculation logic
        return String(format: "%.2f", lastWeekSavings - thisWeekSavings as! CVarArg)
    }
}

struct StatisticCard: View {
    let title: String
    let value: String
    let icon: String
    var isDarkMode: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.purple)
                .padding()
                .background(Color.purple.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(isDarkMode ? .white : .black)
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
            }
            Spacer()
        }
        .padding()
        .background(isDarkMode ? Color(UIColor.systemGray6) : Color(UIColor.systemGray5))
        .cornerRadius(15)
        .shadow(color: isDarkMode ? Color.black.opacity(0.5) : Color.gray.opacity(0.3), radius: 5, x: 0, y: 3)
    }
}

