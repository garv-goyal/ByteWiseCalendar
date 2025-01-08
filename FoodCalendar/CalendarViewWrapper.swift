import SwiftUI

struct CalendarViewWrapper: View {
    @Binding var selectedDate: Date
    @Binding var foodItems: [FoodItem]
    @Binding var isDarkMode: Bool

    @State private var searchQuery = ""
    @State private var filteredItems: [FoodItem] = []
    @State private var isFlipped = false 

    var body: some View {
        VStack(spacing: 0) {
            HeaderSections(
                isDarkMode: $isDarkMode,
                searchQuery: $searchQuery,
                foodItems: $foodItems,
                filteredItems: $filteredItems,
                isFlipped: $isFlipped
            )

            CalendarGridView(
                selectedDate: $selectedDate,
                foodItems: $foodItems,
                isDarkMode: $isDarkMode,
                isFlipped: $isFlipped 
            )
            .background(isDarkMode ? Color(UIColor.systemGray5) : Color.purple.opacity(0.1))
        }
        .background(
            Group {
                if isDarkMode {
                    Color(UIColor.systemGray6)
                } else {
                    LinearGradient(colors: [Color.purple.opacity(0.2), Color.blue.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                }
            }
        )
    }
}


