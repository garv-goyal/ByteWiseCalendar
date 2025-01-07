import SwiftUI

struct CalendarDateCell: View {
    var date: Date
    @Binding var foodItems: [FoodItem]
    @Binding var isDarkMode: Bool // Added isDarkMode binding
    @State private var draggedItem: String?

    var isNextMonthDate: Bool = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Highlight the current date with a special background or border
            if isSpecificDate(date) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.3)) // Background color for the current date
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue, lineWidth: 2) // Border to emphasize the current date
                    )
            } else {
                (isNextMonthDate
                    ? (isDarkMode ? Color(UIColor.systemGray4) : Color.purple.opacity(0.1))
                    : (isDarkMode ? Color(UIColor.systemGray5) : Color.white))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isDarkMode ? Color.white : Color.clear, lineWidth: 1) // White border in dark mode
                    )
            }

            // Display the day number at the top-left corner
            Text(dayString(from: date))
                .font(.headline)
                .foregroundColor(isDarkMode ? Color.white : Color.black) // White in dark mode
                .padding(5)

            // Display the images centered in the cell
            VStack {
                Spacer()
                HStack(spacing: 0) {
                    ForEach(itemsForDate(date: date).prefix(3), id: \.self) { item in
                        Image(item.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 33, height: 37)
                            .padding(4)
                            .onDrag {
                                draggedItem = item.imageName
                                return NSItemProvider(object: item.imageName as NSString)
                            }
                    }
                }
                Spacer()
            }
        }
        .cornerRadius(8) // Rounded corners for the cell
    }

    func isSpecificDate(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let specificDateComponents = DateComponents(year: 2024, month: 11, day: 2)
        let specificDate = calendar.date(from: specificDateComponents)!
        return calendar.isDate(date, inSameDayAs: specificDate)
    }

    func dayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    func itemsForDate(date: Date) -> [FoodItem] {
        foodItems.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
}
