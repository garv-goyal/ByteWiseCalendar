import SwiftUI

enum Tab {
    case calendar
    case recipes
    case inventory
    case settings
    case statistics
}

struct ContentView: View {
    @State private var selectedTab: Tab = .calendar
    @State private var isDarkMode: Bool = false

    @State private var selectedDate = Calendar.current.date(from: DateComponents(year: 2024, month: 11))!
    @State private var foodItems: [FoodItem] = [
        FoodItem(name: "Apple", imageName: "apple", date: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 6))!),
        FoodItem(name: "Chicken", imageName: "chicken", date: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 2))!),
        FoodItem(name: "Banana", imageName: "banana", date: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 3))!),
        FoodItem(name: "Eggs", imageName: "eggs", date: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 3))!),
        FoodItem(name: "Carrot", imageName: "carrot", date: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 6))!),
        FoodItem(name: "Orange", imageName: "orange", date: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 2))!),
        FoodItem(name: "Tomato", imageName: "tomato", date: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 7))!),
        FoodItem(name: "Milk", imageName: "milk", date: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 7))!),
        FoodItem(name: "Potato", imageName: "potato", date: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 1))!)
    ]
    let quickTips = [
        "Store apples separately from bananas to prevent them from ripening too quickly.",
        "Carrots should be stored in a perforated plastic bag in the refrigerator to stay crisp.",
        "Store chicken in the coldest part of the refrigerator and cook it within 1-2 days of purchase.",
        "Keep milk on the middle shelf of the refrigerator to maintain a consistent temperature.",
        "Potatoes should be stored in a cool, dark place to prevent sprouting."
    ]
    
    @State private var currentTipIndex = 0
    @State private var lastWeekSavings: Double = 15.30
    @State private var thisWeekSavings: Double = 5.45
    @State private var searchQuery = ""
    @State private var filteredItems: [FoodItem] = []
    @State private var isFlipped = false

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                Spacer()
                
                switch selectedTab {
                case .calendar:
                    CalendarViewWrapper(selectedDate: $selectedDate, foodItems: $foodItems, isDarkMode: $isDarkMode)
                        .environment(\.colorScheme, isDarkMode ? .dark : .light)
                case .recipes:
                    RecipeRecommendationsView(foodItems: $foodItems, isDarkMode: $isDarkMode)
                        .environment(\.colorScheme, isDarkMode ? .dark : .light)
                case .inventory:
                    FoodInventoryView(foodItems: $foodItems, isDarkMode: $isDarkMode)
                        .environment(\.colorScheme, isDarkMode ? .dark : .light)
                case .settings:
                    SettingsView(isDarkMode: $isDarkMode)
                        .environment(\.colorScheme, isDarkMode ? .dark : .light)
                case .statistics:
                    StatisticsView(foodItems: $foodItems, isDarkMode: $isDarkMode)
                        .environment(\.colorScheme, isDarkMode ? .dark : .light)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, -6.5)
            .background(
                Group {
                    if isDarkMode {
                        Color(UIColor.systemGray6)
                    } else {
                        LinearGradient(colors: [Color.purple.opacity(0.2), Color.blue.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                    }
                }
            )
            
            CustomTabBar(selectedTab: $selectedTab, isDarkMode: $isDarkMode)
        }
        .edgesIgnoringSafeArea(.bottom) 
    }
}
