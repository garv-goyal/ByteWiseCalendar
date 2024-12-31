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

    var body: some View {
        VStack(spacing: 0) {
            // Top Section Layout
            HStack(alignment: .center, spacing: 20) {
                // Left: Grocery List
                VStack(spacing: 8) {
                    // Search Bar
                    TextField("Search items...", text: .constant(""))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)

                    // Compact Scrollable List
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(foodItems.prefix(6), id: \.id) { item in
                                VStack(spacing: 5) {
                                    Image(item.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                    Text(item.name)
                                        .font(.caption)
                                        .foregroundColor(.black)
                                }
                                .padding(6)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding(.leading, 40)
                .frame(width: UIScreen.main.bounds.width * 0.3)

                // Center: Waste Comparison
                VStack(spacing: 10) {
                    Text("Waste Comparison")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    HStack(spacing: 30) {
                        CircularProgressView(label: "Last Week", value: lastWeekSavings, maxValue: 50, color: .yellow)
                        CircularProgressView(label: "This Week", value: thisWeekSavings, maxValue: 50, color: .green)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.purple.opacity(0.5))
                        .shadow(radius: 10)
                )
                .frame(width: UIScreen.main.bounds.width * 0.4)

                // Right: Quick Tips
                VStack(spacing: 10) {
                    Text("Quick Tips")
                        .font(.headline)
                        .padding(8)
                        .background(Color.orange.opacity(0.8))
                        .cornerRadius(8)
                        .foregroundColor(.white)

                    Text(quickTips[currentTipIndex])
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(8)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(10)
                        .onAppear {
                            Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
                                currentTipIndex = (currentTipIndex + 1) % quickTips.count
                            }
                        }
                }
                .padding(.trailing, 35)
                .frame(width: UIScreen.main.bounds.width * 0.3)
            }
            .padding()
            .background(LinearGradient(colors: [Color.purple.opacity(0.2), Color.blue.opacity(0.1)], startPoint: .top, endPoint: .bottom))

            // Calendar Grid View
            CalendarGridView(selectedDate: $selectedDate, foodItems: $foodItems)
                .background(Color.purple.opacity(0.1))
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct CircularProgressView: View {
    let label: String
    let value: Double
    let maxValue: Double
    let color: Color

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.3)
                    .foregroundColor(color)

                Circle()
                    .trim(from: 0.0, to: CGFloat(min(value / maxValue, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .foregroundColor(color)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.easeInOut(duration: 1.0), value: value)

                Text(String(format: "$%.2f", value))
                    .font(.system(size: 14))
                    .fontWeight(.bold)
            }
            .frame(width: 80, height: 80)

            Text(label)
                .font(.caption)
                .foregroundColor(.white)
        }
    }
}
