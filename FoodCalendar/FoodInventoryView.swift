import SwiftUI

struct FoodInventoryView: View {
    @Binding var foodItems: [FoodItem]
    @Binding var isDarkMode: Bool

    init(foodItems: Binding<[FoodItem]>, isDarkMode: Binding<Bool>) {
        self._foodItems = foodItems
        self._isDarkMode = isDarkMode

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemPurple
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 34)
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: isDarkMode
                                       ? [Color.purple.opacity(0.5), Color.blue.opacity(0.3)]
                                       : [Color.purple.opacity(0.3), Color.blue.opacity(0.2)]
                                      ),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: 775, height: 200)
                .cornerRadius(15)
                .padding([.leading, .trailing], 16)

                VStack(spacing: 10) {
                    Image(systemName: "archivebox.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.purple)
                        .shadow(radius: 5)

                    Text("Food Inventory")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(isDarkMode ? Color.white : Color.black)

                    Text("Manage your food items and reduce waste effortlessly.")
                        .font(.subheadline)
                        .foregroundColor(isDarkMode ? Color.white.opacity(0.7) : Color.black.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.trailing, -5)
                        .padding(.horizontal, 16)
                }
                .padding(.top, -14)
            }
            .padding(.top, 18)
            .padding(.bottom, 20)

            Divider()
                .background(Color.purple.opacity(0.3))

            HStack {
                Spacer()
                EditButton()
                    .foregroundColor(.purple)
            }
            .padding()
            .background(isDarkMode ? Color(UIColor.systemGray6) : Color(UIColor.systemGray5))
            .cornerRadius(10)
            .shadow(color: isDarkMode ? Color.black.opacity(0.5) : Color.gray.opacity(0.1), radius: 2, x: 0, y: 2)
            .padding([.leading, .trailing], 16)

            List {
                ForEach(sortedFoodItems(), id: \.id) { item in
                    InventoryRow(foodItem: item, isDarkMode: isDarkMode)
                }
                .onDelete(perform: deleteItems)
            }
            .listStyle(PlainListStyle())
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .background(isDarkMode ? Color.black.opacity(0.05) : Color.white)
            .accentColor(.purple)
        }
        .background(
            Group {
                if isDarkMode {
                    AnyView(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
                } else {
                    AnyView(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple.opacity(0.05), Color.white]),
                            startPoint: .top,
                            endPoint: .bottom
                        ).edgesIgnoringSafeArea(.all)
                    )
                }
            }
        )
        .navigationBarHidden(true)
    }

    func sortedFoodItems() -> [FoodItem] {
        foodItems.sorted { $0.date < $1.date }
    }

    func deleteItems(at offsets: IndexSet) {
        let sortedItems = sortedFoodItems()
        for index in offsets {
            let itemToDelete = sortedItems[index]
            if let originalIndex = foodItems.firstIndex(where: { $0.id == itemToDelete.id }) {
                foodItems.remove(at: originalIndex)
            }
        }
    }
}


import SwiftUI

struct InventoryRow: View {
    let foodItem: FoodItem
    var isDarkMode: Bool

    @State private var showDetails = false
    
    var rowColor: Color {
        let colorMapping: [String: Color] = [
            "Potato": .yellow.opacity(0.2),
            "Chicken": .pink.opacity(0.2),
            "Orange": .orange.opacity(0.2),
            "Banana": .yellow.opacity(0.2),
            "Eggs": .purple.opacity(0.2),
            "Apple": .red.opacity(0.2),
            "Carrot": .green.opacity(0.2),
            "Tomato": .red.opacity(0.2),
            "Milk": .blue.opacity(0.2)
        ]

        return colorMapping[foodItem.name] ?? .gray.opacity(0.2)
    }


    var body: some View {
        HStack {
            Image(foodItem.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .shadow(radius: 2)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 5) {
                Text(foodItem.name)
                    .font(.headline)
                    .foregroundColor(isDarkMode ? .white : .black)

                Text("Expires on \(formattedDate(foodItem.date))")
                    .font(.subheadline)
                    .foregroundColor(isDarkMode ? Color.gray.opacity(0.7) : .secondary)
            }
            .padding(.leading, 5)

            Spacer()

            if isExpiringSoon(date: foodItem.date) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                    .accessibilityLabel("Expiring Soon")
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(rowColor)
        .cornerRadius(10)
        .shadow(color: isDarkMode ? Color.black.opacity(0.1) : Color.gray.opacity(0.1),
                radius: 2, x: 0, y: 2)
        .onTapGesture {
            showDetails.toggle()
        }
        .sheet(isPresented: $showDetails) {
            FoodStatisticsView(foodItem: foodItem, isDarkMode: isDarkMode)
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func isExpiringSoon(date: Date) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        let startOfDate = calendar.startOfDay(for: date)
        guard let twoDaysFromNow = calendar.date(byAdding: .day, value: 2, to: startOfToday) else { return false }
        return startOfDate <= twoDaysFromNow && startOfDate >= startOfToday
    }
}
