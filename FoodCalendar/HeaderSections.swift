import SwiftUI

struct HeaderSections: View {
    @Binding var isDarkMode: Bool
    @Binding var searchQuery: String
    @Binding var foodItems: [FoodItem]
    @Binding var filteredItems: [FoodItem]
    
    @State private var isFlipped = false
    @State private var currentTipIndex = 0
    @State private var lastWeekSavings: Double = 15.30
    @State private var thisWeekSavings: Double = 5.45
    
    let quickTips = [
        "Store apples separately from bananas to prevent them from ripening too quickly.",
        "Carrots should be stored in a perforated plastic bag in the refrigerator to stay crisp.",
        "Store chicken in the coldest part of the refrigerator and cook it within 1-2 days of purchase.",
        "Keep milk on the middle shelf of the refrigerator to maintain a consistent temperature.",
        "Potatoes should be stored in a cool, dark place to prevent sprouting."
    ]
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            searchBarSection()
            wasteComparisonSection()
            quickTipsSection()
        }
        .padding()
        .background(
            Group {
                if isDarkMode {
                    Color(UIColor.systemGray6)
                } else {
                    LinearGradient(colors: [Color.purple.opacity(0.2), Color.blue.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                }
            }
        )
        .onAppear {
            // Initialize filteredItems with all foodItems when the view appears
            filterItems()
        }
    }
    
    @ViewBuilder
    private func searchBarSection() -> some View {
        VStack(spacing: 8) {
            TextField("Search items...", text: $searchQuery)
                .onChange(of: searchQuery) { _ in
                    filterItems()
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .background(isDarkMode ? Color(UIColor.systemGray3).opacity(0.7) : Color.white)
                .cornerRadius(8)
                .foregroundColor(isDarkMode ? Color.white : Color.black)
                .frame(maxWidth: .infinity)
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 10) {
                    // Display all items when not searching, otherwise display filtered items
                    let itemsToShow: [FoodItem] = searchQuery.isEmpty ? foodItems : filteredItems
                    ForEach(itemsToShow, id: \.id) { item in
                        foodItemRow(item: item)
                    }
                }
            }
            .frame(maxHeight: 90)
        }
        .padding(.leading, 40)
        .frame(width: UIScreen.main.bounds.width * 0.3)
    }
    
    @ViewBuilder
    private func wasteComparisonSection() -> some View {
        VStack(spacing: 10) {
            if isFlipped {
                Text("Additional Info")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(isDarkMode ? Color.white : Color.black)
                
                Text("Last week you saved 30% more than this week. Focus on reducing waste this week!")
                    .font(.subheadline)
                    .foregroundColor(isDarkMode ? Color.white : Color.black)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(isDarkMode ? Color.teal.opacity(0.3) : Color.teal.opacity(0.9))
                    .cornerRadius(10)
                
            } else {
                Text("Waste Comparison")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(isDarkMode ? Color.white : Color.black)
                
                HStack(spacing: 25) {
                    CircularProgressView(label: "Last Week", value: lastWeekSavings, maxValue: 50, color: .yellow)
                    CircularProgressView(label: "This Week", value: thisWeekSavings, maxValue: 50, color: .green)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(isDarkMode ? (isFlipped ?  Color.teal.opacity(0.5) : Color.purple.opacity(0.5)) : (isFlipped ?  Color.teal.opacity(0.4) : Color.purple.opacity(0.5)))
                .shadow(radius: 10)
        )
        .frame(width: UIScreen.main.bounds.width * 0.4)
        .onTapGesture {
            withAnimation {
                isFlipped.toggle()
            }
        }
    }
    
    @ViewBuilder
    private func quickTipsSection() -> some View {
        VStack(spacing: 10) {
            HStack {
                Text("Quick Tips")
                    .font(.headline)
                    .padding(8)
                    .background(isDarkMode ? Color(UIColor.systemOrange).opacity(0.8) : Color.orange.opacity(0.8))
                    .cornerRadius(8)
                    .foregroundColor(isDarkMode ? Color.black : Color.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.leading, 38)
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        isDarkMode.toggle()
                    }
                }) {
                    Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(isDarkMode ? .yellow : .white)
                        .padding(5)
                        .background(Circle().fill(isDarkMode ? Color(UIColor.systemGray4) : Color.blue))
                        .shadow(radius: 3)
                }
            }
            
            Text(quickTips[currentTipIndex])
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(8)
                .background(isDarkMode ? Color(UIColor.systemGray3) : Color.orange.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(isDarkMode ? Color.white : Color.black)
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
                        currentTipIndex = (currentTipIndex + 1) % quickTips.count
                    }
                }
        }
        .padding(.trailing, 38)
        .frame(width: UIScreen.main.bounds.width * 0.3)
    }
    
    @ViewBuilder
    private func foodItemRow(item: FoodItem) -> some View {
        HStack(spacing: 10) {
            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 5) {
                Text(item.name)
                    .font(.caption)
                    .foregroundColor(isDarkMode ? Color.white : Color.black)
                Text("Stored Date: \(formattedDate(item.date))")
                    .font(.caption2)
                    .foregroundColor(isDarkMode ? Color(UIColor.lightGray) : Color.gray)
            }
        }
        .padding(6)
        .background(isDarkMode ? Color(UIColor.systemGray5) : Color.purple.opacity(0.2))
        .cornerRadius(10)
    }
    
    func filterItems() {
        if searchQuery.isEmpty {
            // Show all items when the search query is empty
            filteredItems = foodItems
        } else {
            // Filter items based on the search query
            filteredItems = foodItems.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
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
            .frame(width: 65, height: 65)

            Text(label)
                .font(.caption)
                .foregroundColor(.white)
        }
    }
}
