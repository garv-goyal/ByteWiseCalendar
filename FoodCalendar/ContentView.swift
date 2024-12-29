import SwiftUI

struct ContentView: View {
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
    let grocerySuggestions = ["Chicken 🍗", "Milk 🥛", "Apple 🍎", "Banana 🍌", "Egg 🥚", "Carrot 🥕", "Orange 🍑", "Tomato 🍅", "Potato 🥔"]

    let itemDetails: [String: String] = [
        "Chicken 🍗": "Estimated Expiry: 2-3 days\nCalories: 239/100g\nProtein: 27g\nVitamin B6: 30% of DV",
        "Milk 🥛": "Estimated Expiry: 5-7 days\nCalories: 42/100g\nCalcium: 12% of DV\nProtein: 3.4g",
        "Apple 🍎": "Estimated Expiry: 5-7 days\nCalories: 52/100g\nFiber: 2.4g\nVitamin C: 7% of DV",
        "Banana 🍌": "Estimated Expiry: 4-6 days\nCalories: 96/100g\nPotassium: 358mg\nVitamin B6: 20% of DV",
        "Egg 🥚": "Estimated Expiry: 21-28 days\nCalories: 155/100g\nProtein: 13g\nVitamin D: 21% of DV",
        "Carrot 🥕": "Estimated Expiry: 14-21 days\nCalories: 41/100g\nFiber: 2.8g\nVitamin A: 334% of DV",
        "Orange 🍑": "Estimated Expiry: 7-10 days\nCalories: 47/100g\nVitamin C: 89% of DV\nFiber: 2.4g",
        "Tomato 🍅": "Estimated Expiry: 5-7 days\nCalories: 18/100g\nVitamin C: 28% of DV\nLycopene: Antioxidant",
        "Potato 🥔": "Estimated Expiry: 28-35 days\nCalories: 77/100g\nCarbs: 17g\nVitamin C: 32% of DV"
    ]

    let quickTips = [
        "Store apples separately from bananas to prevent them from ripening too quickly.",
        "Bananas emit ethylene gas, so keep them away from other fruits to slow down ripening.",
        "Carrots should be stored in a perforated plastic bag in the refrigerator to stay crisp.",
        "Keep oranges in the refrigerator for longer shelf life, but can be at room temperature up to a week.",
        "Eggs should be stored in the refrigerator to prevent them from absorbing strong odors.",
        "Store chicken in the coldest part of the refrigerator and cook it within 1-2 days of purchase.",
        "Store tomatoes at room temperature and avoid refrigeration to maintain their flavor.",
        "Potatoes should be stored in a cool, dark place, to prevent them from becoming sweet or grainy.",
        "Keep milk on the middle shelf of the refrigerator, not the door, to maintain a consistent temperature.",
        "Wrap celery in aluminum foil before refrigerating to keep it fresh and crunchy."
    ]

    @State private var currentTipIndex = 0 // Index for the current tip
    @State private var selectedItem: String? // State to track the selected item for showing details
    @State private var lastWeekSavings: Double = 15.30 // Placeholder value for last week's savings
    @State private var thisWeekSavings: Double = 5.45 // Placeholder value for this week's savings

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                // Improved Grocery list on the top left
                VStack(alignment: .leading) {
                    Text("Grocery List")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .padding(8)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.4)]),
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
                        )
                        .cornerRadius(10)
                        .foregroundColor(.white)

                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(grocerySuggestions, id: \.self) { item in
                                HStack {
                                    Text(item)
                                        .font(.system(size: 13, weight: .medium, design: .rounded))
                                        .padding(8)
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(8)
                                        .foregroundColor(.black)
                                        .onTapGesture {
                                            // Show item details when clicked
                                            selectedItem = item
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                selectedItem = nil // Dismiss after 3 seconds
                                            }
                                        }
                                }
                            }
                        }
                    }
                    .frame(height: 110) // Limit the height to show only 2 items initially
                }
                .padding(.leading)

                Spacer(minLength: 133) // Add space to push "Money Saved" to the center

                // Enhanced "Money Saved" comparison section
                VStack {
                    Text("Waste Comparison")
                        .font(.system(size: 30, weight: .bold, design: .rounded)) // Increased font size
                        .foregroundColor(.white)
                        .padding(8) // Increased padding
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.4)]),
                                           startPoint: .top,
                                           endPoint: .bottom)
                        )
                        .cornerRadius(12) // Slightly larger radius
                        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 4) // Increased shadow for emphasis

                    HStack(spacing: 10) { // Increased spacing between columns
                        VStack {
                            Text("Last Week")
                                .font(.system(size: 24, weight: .bold, design: .rounded)) // Larger text size
                                .foregroundColor(.white)
                            Text("$\(String(format: "%.2f", lastWeekSavings))")
                                .font(.system(size: 26, weight: .bold, design: .rounded)) // Larger value font size
                                .foregroundColor(.black)
                        }
                        .padding(9) // Increased padding
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.4)]),
                                           startPoint: .top,
                                           endPoint: .bottom)
                        )
                        .cornerRadius(12) // Slightly larger radius
                        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 4) // Stronger shadow

                        VStack {
                            Text("This Week")
                                .font(.system(size: 24, weight: .bold, design: .rounded)) // Larger text size
                                .foregroundColor(.white)
                            Text("$\(String(format: "%.2f", thisWeekSavings))")
                                .font(.system(size: 26, weight: .bold, design: .rounded)) // Larger value font size
                                .foregroundColor(.black)
                        }
                        .padding(9) // Increased padding
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.4)]),
                                           startPoint: .top,
                                           endPoint: .bottom)
                        )
                        .cornerRadius(12) // Slightly larger radius
                        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 4) // Stronger shadow
                    }
                }
                .zIndex(1) // Ensure the "Savings Comparison" section stays on top of other views

                Spacer() // Add space to center the "Savings Comparison" section

                // Right side "Quick Tips" section with animation
                VStack(alignment: .leading) {
                    Text("Quick Tips")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .padding(8)
                        .background(Color.orange.opacity(0.7))
                        .cornerRadius(10)
                        .foregroundColor(.white)

                    Text(quickTips[currentTipIndex])
                        .font(.system(size: 16, design: .rounded))
                        .padding(8)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .transition(.slide) // Add transition animation
                        .fixedSize(horizontal: false, vertical: true) // Allow wrapping
                        .id(currentTipIndex) // Add an ID to help with animation tracking
                }
                .frame(width: 215) // Adjust width as needed
                .padding(.trailing)
                .onAppear {
                    // Timer to change the tip every 5 seconds
                    Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
                        withAnimation(.easeInOut) {
                            currentTipIndex = (currentTipIndex + 1) % quickTips.count
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: UIScreen.main.bounds.height * 0.18) // Adjust height of the top section
            .padding(.top, 7)
            .background {
                // Display the selected item information as an overlay
                if let item = selectedItem {
                    VStack {
                        Text(itemDetails[item] ?? "No details available")
                            .font(.system(size: 9.5, weight: .medium, design: .rounded))
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 3)
                    }
                    .frame(maxWidth: 170) // Fixed width for information box
                    .offset(x: -219, y: 20) // Adjust position as needed
                    .zIndex(2) // Ensure it stays above other views
                }
            }

            // Bottom part for the calendar
            CalendarGridView(selectedDate: $selectedDate, foodItems: $foodItems)
                .background(Color.purple.opacity(0.4))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .edgesIgnoringSafeArea(.all)
    }
}


