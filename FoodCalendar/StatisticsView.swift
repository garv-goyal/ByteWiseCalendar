import SwiftUI

struct StatisticsView: View {
    @Binding var foodItems: [FoodItem]
    @Binding var isDarkMode: Bool
    
    @State private var lastWeekSavings: Double = 15.30
    @State private var thisWeekSavings: Double = 5.45
    
    var body: some View {
        ZStack {
            if isDarkMode {
                Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all)
            } else {
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple.opacity(0.1), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            }
            
            ScrollView {
                VStack(spacing: 20) {
                    let specifiedDate = Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 2))!
                    let expiringSoonCount = itemsExpiringSoon(from: specifiedDate).count
                    
                    FancyHeader(isDarkMode: isDarkMode)
                
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            StatisticCard(
                                title: "Total Items",
                                value: "\(foodItems.count)",
                                icon: "cart.fill",
                                isDarkMode: isDarkMode
                            )
                            .padding(.leading, 13)
                            

                            StatisticCard(
                                title: "Expiring Soon",
                                value: "\(expiringSoonCount)",
                                icon: "timer",
                                isDarkMode: isDarkMode
                            )
                            

                            StatisticCard(
                                title: "Weekly Savings",
                                value: "$\(calculateWeeklySavings())",
                                icon: "dollarsign.circle.fill",
                                isDarkMode: isDarkMode
                            )
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                    }
                    .padding(.top, -30)
                    
                    VStack(spacing: 15) {
                        Text("Weekly Savings Progress")
                            .font(.headline)
                            .foregroundColor(isDarkMode ? .white : .black)
                        
                        CircularRingView(
                            progress: ringProgressValue(),
                            isDarkMode: isDarkMode
                        )
                        .frame(width: 150, height: 150)
                        
                        Text("$\(lastWeekSavings - thisWeekSavings, specifier: "%.2f") saved compared to last week")
                            .font(.subheadline)
                            .foregroundColor(isDarkMode ? .gray : .secondary)
                            .padding(.horizontal, 30)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(isDarkMode ? Color(UIColor.systemGray6) : Color(UIColor.systemGray6))
                    .cornerRadius(15)
                    .shadow(color: isDarkMode ? Color.black.opacity(0.5) : Color.gray.opacity(0.1), radius: 5, x: 0, y: 3)
                    .padding(.horizontal, 16)
                    
                    VStack(spacing: 15) {
                        Text("Expiring Soon by Day (Next 5 days from Nov 2, 2024)")
                            .font(.headline)
                            .foregroundColor(isDarkMode ? .white : .black)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                let specifiedDate = Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 2))!
                                let calendar = Calendar.current
                                let startOfSpecifiedDate = calendar.startOfDay(for: specifiedDate)
                                
                                ForEach(1...5, id: \.self) { offset in
                                    if let targetDate = calendar.date(byAdding: .day, value: offset, to: startOfSpecifiedDate) {
                                        let dayItems = foodItems.filter { calendar.isDate($0.date, inSameDayAs: targetDate) }
                                        DayExpiringColumn(dayOffset: offset, items: dayItems, isDarkMode: isDarkMode)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .frame(width: 720, height: 150)
                    .padding()
                    .background(isDarkMode ? Color(UIColor.systemGray6) : Color(UIColor.systemGray6))
                    .cornerRadius(15)
                    .shadow(color: isDarkMode ? Color.black.opacity(0.5) : Color.gray.opacity(0.5), radius: 5, x: 0, y: 3)
                    .padding(.horizontal, 16)


                    VStack {
                        Text("Advanced or Additional Stats Here")
                            .foregroundColor(isDarkMode ? .white : .black)
                            .font(.title3)
                            .padding()
                        
                        Text("Feel free to add more data, charts, or info here!")
                            .font(.subheadline)
                            .foregroundColor(isDarkMode ? .gray : .secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(isDarkMode ? Color(UIColor.systemGray6) : Color(UIColor.systemGray6))
                    .cornerRadius(15)
                    .shadow(color: isDarkMode ? Color.black.opacity(0.5) : Color.gray.opacity(0.5), radius: 5, x: 0, y: 3)
                    .padding([.horizontal, .bottom], 16)
                }
                .padding(.top, 10)
                .accentColor(.purple)
            }
        }
    }
    

    func itemsExpiringSoon(from specifiedDate: Date) -> [FoodItem] {
        let calendar = Calendar.current
        let startOfSpecifiedDate = calendar.startOfDay(for: specifiedDate)
        
        guard let threeDaysAfter = calendar.date(byAdding: .day, value: 3, to: startOfSpecifiedDate) else {
            return []
        }
        
        return foodItems.filter { item in
            let startOfItem = calendar.startOfDay(for: item.date)
            return startOfItem >= startOfSpecifiedDate && startOfItem <= threeDaysAfter
        }
    }


    func calculateWeeklySavings() -> String {
        let diff = lastWeekSavings - thisWeekSavings
        return String(format: "%.2f", diff)
    }
    
    func ringProgressValue() -> Double {
        let totalGoal: Double = 20.0
        let difference = lastWeekSavings - thisWeekSavings
        let progress = difference / totalGoal
        return max(0, min(progress, 1))
    }
    
    func barChartDataForExpiringSoon(from startDate: Date) -> [Double] {
        let calendar = Calendar.current
        let startOfSpecified = calendar.startOfDay(for: startDate)
        
        return (1...5).map { offset in
            if let date = calendar.date(byAdding: .day, value: offset, to: startOfSpecified) {
                let count = foodItems.filter { calendar.isDate($0.date, inSameDayAs: date) }.count
                return Double(count)
            } else {
                return 0.0
            }
        }
    }
}


struct FancyHeader: View {
    var isDarkMode: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: isDarkMode
                                   ? [Color.purple.opacity(0.5), Color.blue.opacity(0.3)]
                                   : [Color.purple.opacity(0.3), Color.blue.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(width: 775, height: 200)
            .cornerRadius(15)
            .shadow(radius: 5)
            .padding()
            .padding([.leading, .bottom, .trailing], 16)
            
            VStack(spacing: 10) {
                Image(systemName: "calendar.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(isDarkMode ? Color.purple : Color.purple.opacity(1.5))
                    .shadow(radius: 5)
                    .padding(.trailing, -30)
                
                Text("Statistics")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(isDarkMode ? Color.white : Color.black)
                    .padding(.trailing, -30)
                
                Text("See how you're doing this week")
                    .font(.subheadline)
                    .foregroundColor(isDarkMode ? Color.white.opacity(0.7) : Color.black.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.leading, 16)
                    .padding(.trailing, -15)
            }
            .padding(.bottom, 30)
            .padding(.trailing, 30)
        }
        .padding(.top, -8)
        .padding(.bottom, -5)
        
        Divider()
            .padding(.top, -27)
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
                .scaledToFit()
                .frame(width: 35, height: 35)
                .foregroundColor(.purple)
                .padding()
                .background(Color.purple.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
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
        .frame(width: 250)
        .background(isDarkMode ? Color(UIColor.systemGray6) : Color(UIColor.systemGray6))
        .cornerRadius(15)
        .shadow(color: isDarkMode ? Color.black.opacity(0.5) : Color.gray.opacity(0.1), radius: 5, x: 0, y: 3)
    }
}


struct CircularRingView: View {
    let progress: Double 
    var isDarkMode: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 1)
                .stroke(
                    isDarkMode ? Color.white.opacity(0.1) : Color.purple.opacity(0.2),
                    style: StrokeStyle(lineWidth: 15, lineCap: .round)
                )
            
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(
                    Color.purple,
                    style: StrokeStyle(lineWidth: 15, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 1), value: progress)
            
            Text("\(Int(progress * 100))%")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(isDarkMode ? .white : .purple)
        }
    }
}


struct MiniBarChart: View {
    let data: [Double]
    var isDarkMode: Bool
    
    var body: some View {
        if data.isEmpty {
            Text("No data available")
                .font(.subheadline)
                .foregroundColor(isDarkMode ? .gray : .secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            GeometryReader { geo in
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(data.indices, id: \.self) { index in
                        let maxVal = data.max() ?? 1
                        let barHeight = maxVal == 0 ? 0 : CGFloat(data[index] / maxVal) * geo.size.height
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.purple.opacity(0.7))
                            .frame(
                                width: max(((geo.size.width / CGFloat(data.count)) - 8), 1),
                                height: barHeight
                            )
                    }
                }
            }
        }
    }
}


struct ExpiringSoonCard: View {
    let foodItem: FoodItem
    var isDarkMode: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Image(foodItem.imageName)
                .renderingMode(.original)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .shadow(radius: 2)

            Text(foodItem.name)
                .font(.headline)
                .foregroundColor(isDarkMode ? .white : .black)
            
            Text(formattedDate(foodItem.date))
                .font(.subheadline)
                .foregroundColor(isDarkMode ? .gray.opacity(0.7) : .secondary)
        }
        .padding()
        .background(isDarkMode ? Color(UIColor.systemGray6) : Color(UIColor.systemGray5))
        .cornerRadius(15)
        .shadow(color: isDarkMode ? Color.black.opacity(0.3) : Color.gray.opacity(0.3), radius: 3, x: 0, y: 2)
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct DayExpiringColumn: View {
    let dayOffset: Int
    let items: [FoodItem]
    var isDarkMode: Bool
    
    var body: some View {
        VStack(spacing: 5) {
            Text(dayLabel(for: dayOffset))
                .font(.caption)
                .foregroundColor(isDarkMode ? .white : .black)
            
            VStack(spacing: 2) {
                ForEach(items.prefix(3), id: \.id) { item in
                    Image(item.imageName)
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .shadow(radius: 1)
                }
            }
            .frame(width: 120, height: 70)
            .padding(.trailing, -6)
            
            Text("\(items.count) items")
                .font(.caption2)
                .foregroundColor(isDarkMode ? .white : .black)
        }
        .padding(8)
        .background(isDarkMode ? Color.purple.opacity(0.2) : Color.purple.opacity(0.1))
        .cornerRadius(10)
        .shadow(color: isDarkMode ? Color.black.opacity(0.3) : Color.gray.opacity(0.3), radius: 3, x: 0, y: 2)
    }
    
    func dayLabel(for offset: Int) -> String {
        let calendar = Calendar.current
        if let date = calendar.date(byAdding: .day, value: offset, to: calendar.startOfDay(for: Date())) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.string(from: date)
        }
        return ""
    }
}



struct DayExpiringItemsBar: View {
    let dayOffset: Int
    let items: [FoodItem]
    let maxCount: Double
    var isDarkMode: Bool
    let totalWidth: CGFloat

    var body: some View {
        GeometryReader { geo in
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 2) {
                        ForEach(items, id: \.id) { item in
                            Image(item.imageName)
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 20, height: 20)
                                .clipShape(Circle())
                        }
                    }
                }
                .frame(height: 24)
                
                Spacer()
                
                let heightFactor = maxCount == 0 ? 0 : CGFloat(Double(items.count) / maxCount)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.purple.opacity(0.7))
                    .frame(width: (totalWidth / 5) - 8, height: heightFactor * geo.size.height)
            }
        }
        .frame(width: totalWidth / 5)
    }
}

