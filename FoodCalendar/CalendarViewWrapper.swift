//
//  CalendarViewWrapper.swift
//  FoodCalendar
//
//  Created by Garv Goyal on 1/5/25.
//


import SwiftUI

struct CalendarViewWrapper: View {
    @Binding var selectedDate: Date
    @Binding var foodItems: [FoodItem]
    @Binding var isDarkMode: Bool
    
    @State private var searchQuery = ""
    @State private var filteredItems: [FoodItem] = []
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderSections(isDarkMode: $isDarkMode, searchQuery: $searchQuery, foodItems: $foodItems, filteredItems: $filteredItems)
            
            CalendarGridView(selectedDate: $selectedDate, foodItems: $foodItems, isDarkMode: $isDarkMode)
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
