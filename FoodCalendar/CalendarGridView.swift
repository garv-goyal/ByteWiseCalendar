import SwiftUI

struct CalendarGridView: View {
    @Binding var selectedDate: Date
    @Binding var foodItems: [FoodItem]
    @State private var deletedItems: [FoodItem] = []
    @State private var showCamera = false
    @State private var capturedImage: UIImage?
    @Binding var isDarkMode: Bool
    @Binding var isFlipped: Bool

    let columns = Array(repeating: GridItem(.flexible(), spacing: -70), count: 7)
    let dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack(spacing: 5) {
                    ForEach(dayNames, id: \.self) { day in
                        Text(day)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: (geometry.size.width / 7.55) - 6, height: 20)
                            .background(Color.purple.opacity(0.9))
                            .cornerRadius(5)
                    }
                }
                .padding(.bottom, 4)
                .padding(.trailing, 2)
                .padding(.leading, 2)

                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(generatePreviousMonthDates(), id: \.self) { date in
                        CalendarDateCell(date: date, foodItems: .constant([]), isDarkMode: $isDarkMode, isNextMonthDate: true)
                            .frame(width: (geometry.size.width / 7.55) - 6, height: (geometry.size.width / 8.20) * 1.26)
                            .background(Color.purple.opacity(0.1))
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                    }

                    ForEach(generateDates(), id: \.self) { date in
                        CalendarDateCell(date: date, foodItems: $foodItems, isDarkMode: $isDarkMode, isNextMonthDate: false)
                            .frame(width: (geometry.size.width / 7.55) - 6, height: (geometry.size.width / 8.20) * 1.26)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                    }
                    
                    ForEach(generateNextMonthDates(), id: \.self) { date in
                        CalendarDateCell(date: date, foodItems: .constant([]), isDarkMode: $isDarkMode, isNextMonthDate: true)
                            .frame(width: (geometry.size.width / 7.55) - 6, height: (geometry.size.width / 8.20) * 1.26)
                            .background(Color.purple.opacity(0.2))
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                    }
                }
                .padding(.trailing, 2)
                .padding(.leading, 2)
            
                
                HStack(spacing: 3) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.purple.opacity(0.3))
                            .frame(
                                width: 320,
                                height: isFlipped ? 70 : 75
                            )
                        
                        Text(monthYearString(from: selectedDate))
                            .font(.system(size: isFlipped ? 60 : 60, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(isDarkMode ? Color.white : Color.black)
                    }
                    .padding(.leading, 40)
                    .padding(.bottom, isFlipped ? 10 : 2)

                    Spacer()

                    HStack(spacing: 7) {
                        
                        VStack {
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.purple.opacity(0.3))
                                    .frame(width: 100, height: isFlipped ? 70 : 75)

                                Image("pacman")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 95, height: 60)
                                    .foregroundColor(.black)
                                    .padding(5)
                                    .onDrop(of: [.text], isTargeted: nil) { providers in
                                        handleDrop(providers: providers)
                                    }
                            }
                            Spacer()
                                .padding(.bottom, isFlipped ? 10 : 2)
                        }
                        
                        VStack {
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.purple.opacity(0.3))
                                    .frame(width: 100, height: isFlipped ? 70 : 75)

                                Image(systemName: "arrow.uturn.backward")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 95, height: 60)
                                    .foregroundColor(isDarkMode ? Color.white : Color.black)
                                    .padding(5)
                            }
                            .onTapGesture {
                                undoDelete()
                            }
                            .disabled(deletedItems.isEmpty)
                            .opacity(deletedItems.isEmpty ? 0.5 : 1.0)
                            Spacer()
                                .padding(.bottom, isFlipped ? 10 : 2)
                        }

                        VStack {
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.purple.opacity(0.3))
                                    .frame(width: 100, height: isFlipped ? 70 : 75)

                                Image(systemName: "trash")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 95, height: 60)
                                    .foregroundColor(isDarkMode ? Color.white : Color.black)
                                    .padding(5)
                                    .onDrop(of: [.text], isTargeted: nil) { providers in
                                        handleDrop(providers: providers)
                                    }
                            }
                            Spacer()
                                .padding(.bottom, isFlipped ? 10 : 2)
                        }

                        VStack {
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.purple.opacity(0.3))
                                    .frame(width: 100, height: isFlipped ? 70 : 75)
                                
                                Image(systemName: "camera")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 95, height: 60)
                                    .foregroundColor(isDarkMode ? Color.white : Color.black)
                                    .padding(5)
                                    .onTapGesture {
                                        showCamera = true
                                    }
                            }
                            Spacer()
                                .padding(.bottom, isFlipped ? 10 : 2)
                        }
                    }
                    .padding(.trailing, 40)
                }
                .frame(height: 90)
                .sheet(isPresented: $showCamera) {
                    CameraView(isPresented: $showCamera, image: $capturedImage)
                }
            }
        }
    }

    func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM YYYY"
        return formatter.string(from: date)
    }

    func generatePreviousMonthDates() -> [Date] {
        var previousMonthDates: [Date] = []
        let calendar = Calendar.current
        let startOfMonth = calendar.date(
            from: calendar.dateComponents([.year, .month], from: selectedDate)
        )!
        let firstWeekdayOfMonth = calendar.component(.weekday, from: startOfMonth)
        let daysToShow = firstWeekdayOfMonth - 1
    
        let previousMonth = calendar.date(byAdding: .month, value: -1, to: startOfMonth)!
        let range = calendar.range(of: .day, in: .month, for: previousMonth)!
        let totalDaysPreviousMonth = range.count
        let startDay = totalDaysPreviousMonth - daysToShow + 1
        
        for day in startDay...totalDaysPreviousMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: previousMonth) {
                previousMonthDates.append(date)
            }
        }
        
        return previousMonthDates
    }
    
    
    func generateNextMonthDates() -> [Date] {
        var nextMonthDates: [Date] = []
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))!
        let range = calendar.range(of: .day, in: .month, for: selectedDate)!
        let lastDayOfMonth = calendar.date(byAdding: .day, value: range.count - 1, to: startOfMonth)!
        let lastWeekday = calendar.component(.weekday, from: lastDayOfMonth)
        let daysToShow = 7 - lastWeekday
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
        
        for day in 1...daysToShow {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: nextMonth) {
                nextMonthDates.append(date)
            }
        }
        
        return nextMonthDates
    }

    func generateDates() -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: selectedDate)!
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))!

        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                dates.append(date)
            }
        }
        return dates
    }

    func handleDrop(providers: [NSItemProvider]) -> Bool {
        for provider in providers {
            if provider.canLoadObject(ofClass: NSString.self) {
                _ = provider.loadObject(ofClass: NSString.self) { object, error in
                    if let imageName = object as? String {
                        DispatchQueue.main.async {
                            if let itemToDelete = foodItems.first(where: { $0.imageName == imageName }) {
                                deletedItems.append(itemToDelete)
                                foodItems.removeAll { $0.imageName == imageName }
                            }
                        }
                    }
                }
                return true
            }
        }
        return false
    }

    func undoDelete() {
        if let lastItem = deletedItems.popLast() {
            foodItems.append(lastItem)
        }
    }
}
