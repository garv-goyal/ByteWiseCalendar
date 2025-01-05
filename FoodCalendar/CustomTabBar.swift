import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    @Binding var isDarkMode: Bool
    
    var body: some View {
        HStack {
            Spacer()
            
            TabBarButton(selectedTab: $selectedTab, currentTab: .calendar, icon: "calendar", label: "Calendar")
            
            Spacer()
            
            TabBarButton(selectedTab: $selectedTab, currentTab: .recipes, icon: "book", label: "Recipes")
            
            Spacer()
            
            TabBarButton(selectedTab: $selectedTab, currentTab: .inventory, icon: "list.bullet", label: "Inventory")
            
            Spacer()
            
            TabBarButton(selectedTab: $selectedTab, currentTab: .settings, icon: "gearshape", label: "Settings")
            
            Spacer()
            
            TabBarButton(selectedTab: $selectedTab, currentTab: .statistics, icon: "chart.bar", label: "Statistics")
            
            Spacer()
        }
        .padding(.vertical, 10)
        .background(isDarkMode ? Color(UIColor.systemGray6) : Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
    }
}

struct TabBarButton: View {
    @Binding var selectedTab: Tab
    var currentTab: Tab
    var icon: String
    var label: String
    
    var body: some View {
        Button(action: {
            selectedTab = currentTab
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(selectedTab == currentTab ? .purple : .gray)
                
                Text(label)
                    .font(.caption)
                    .foregroundColor(selectedTab == currentTab ? .purple : .gray)
            }
        }
    }
}
