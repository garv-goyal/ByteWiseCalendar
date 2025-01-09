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

    @State private var selectedDate = Date()
    @State private var foodItems: [FoodItem] = [
        FoodItem(name: "Apple", imageName: "apple", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 15))!),
        FoodItem(name: "Apple", imageName: "apple", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 15))!),
        FoodItem(name: "Apple", imageName: "apple", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 15))!),
        FoodItem(name: "Apple", imageName: "apple", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 15))!),
        FoodItem(name: "Apple", imageName: "apple", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 15))!),
        FoodItem(name: "Apple", imageName: "apple", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 15))!),
        FoodItem(name: "Apple", imageName: "apple", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 15))!),
        FoodItem(name: "Apple", imageName: "apple", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 15))!),
        FoodItem(name: "Chicken", imageName: "chicken", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 12))!),
        FoodItem(name: "Banana", imageName: "banana", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 13))!),
        FoodItem(name: "Eggs", imageName: "eggs", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 20))!),
        FoodItem(name: "Carrot", imageName: "carrot", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 17))!),
        FoodItem(name: "Orange", imageName: "orange", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 14))!),
        FoodItem(name: "Tomato", imageName: "tomato", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 16))!),
        FoodItem(name: "Milk", imageName: "milk", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 15))!),
        FoodItem(name: "Potato", imageName: "potato", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 22))!),
        FoodItem(name: "Flour", imageName: "flour", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 30))!),
        FoodItem(name: "Sugar", imageName: "sugar", date: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 10))!),
        FoodItem(name: "Butter", imageName: "butter", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 30))!),
        FoodItem(name: "Lettuce", imageName: "lettuce", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 15))!),
        FoodItem(name: "Honey", imageName: "honey", date: Calendar.current.date(from: DateComponents(year: 2025, month: 7, day: 10))!),
        FoodItem(name: "Chocolate", imageName: "chocolate", date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 10))!),
        FoodItem(name: "Cucumber", imageName: "cucumber", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 17))!),
        FoodItem(name: "Feta Cheese", imageName: "fetacheese", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 24))!),
        FoodItem(name: "Olives", imageName: "olives", date: Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 9))!),
        FoodItem(name: "Lemon", imageName: "lemon", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 20))!),
        FoodItem(name: "Garlic", imageName: "garlic", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 30))!),
        FoodItem(name: "Spaghetti", imageName: "spaghetti", date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 10))!),
        FoodItem(name: "Bacon", imageName: "bacon", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 17))!),
//        FoodItem(name: "Parmesan", imageName: "parmesan", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 30))!),
//        FoodItem(name: "Mango", imageName: "mango", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 13))!),
//        FoodItem(name: "Lime", imageName: "lime", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 20))!),
//        FoodItem(name: "Bell Peppers", imageName: "bellpeppers", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 17))!),
//        FoodItem(name: "Rice", imageName: "rice", date: Calendar.current.date(from: DateComponents(year: 2025, month: 7, day: 10))!),
//        FoodItem(name: "Spinach", imageName: "spinach", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 15))!),
//        FoodItem(name: "Almond Milk", imageName: "almondmilk", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 20))!),
//        FoodItem(name: "Pumpkin", imageName: "pumpkin", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 25))!),
//        FoodItem(name: "Cream", imageName: "cream", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 20))!),
//        FoodItem(name: "Cinnamon", imageName: "cinnamon", date: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 10))!),
//        FoodItem(name: "Beef", imageName: "beef", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 15))!),
//        FoodItem(name: "Tortilla", imageName: "tortilla", date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 30))!)
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
