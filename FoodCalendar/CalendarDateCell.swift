import SwiftUI

struct CalendarDateCell: View {
    var date: Date
    @Binding var foodItems: [FoodItem]
    @Binding var isDarkMode: Bool
    @State private var draggedItem: String?

    var isNextMonthDate: Bool = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            if isToday(date) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue, lineWidth: 2)
                    )
            } else {
                (isNextMonthDate
                    ? (isDarkMode ? Color(UIColor.systemGray4) : Color.purple.opacity(0.1))
                    : (isDarkMode ? Color(UIColor.systemGray5) : Color.white))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isDarkMode ? Color.white : Color.clear, lineWidth: 1)
                    )
            }

            Text(dayString(from: date))
                .font(.headline)
                .foregroundColor(isDarkMode ? Color.white : Color.black)
                .padding(5)

            VStack {
                Spacer()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(itemsForDate(date: date), id: \.id) { item in
                            Image(item.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 35)
                                .padding(4)
                                .onDrag {
                                    draggedItem = item.imageName
                                    return NSItemProvider(object: item.imageName as NSString)
                                }
                        }
                    }
                }
                .padding(.horizontal, 4)
                Spacer()
            }
        }
        .cornerRadius(8)
    }

    func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
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

