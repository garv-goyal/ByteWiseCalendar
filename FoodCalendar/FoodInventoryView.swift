import SwiftUI

struct FoodInventoryView: View {
    @Binding var foodItems: [FoodItem]
    @Binding var isDarkMode: Bool
    
    private let columns = [
        GridItem(.flexible(minimum: 80), spacing: 10),
        GridItem(.flexible(minimum: 80), spacing: 10),
        GridItem(.flexible(minimum: 80), spacing: 10)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(
                        colors: isDarkMode
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
            
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                    ForEach(sortedFoodItems(), id: \.id) { item in
                        InventoryCard(
                            foodItem: item,
                            isDarkMode: isDarkMode
                        ) {
                            deleteItem(item)
                        }
                    }
                }
                .padding(.top, 10)
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
            .padding(.bottom, 20)
        }
        .background(
            Group {
                if isDarkMode {
                    Color(UIColor.systemGray6)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.purple.opacity(0.05), Color.white]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .edgesIgnoringSafeArea(.all)
                }
            }
        )
        .navigationBarHidden(true)
    }
    
    
    func sortedFoodItems() -> [FoodItem] {
        foodItems.sorted { $0.date < $1.date }
    }
    
    func deleteItem(_ item: FoodItem) {
        if let index = foodItems.firstIndex(where: { $0.id == item.id }) {
            foodItems.remove(at: index)
        }
    }
}


struct InventoryCard: View {
    let foodItem: FoodItem
    var isDarkMode: Bool
    var onDelete: () -> Void
    
    @State private var showDetails = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: backgroundGradientColors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: isDarkMode
                        ? Color.black.opacity(0.2)
                        : Color.gray.opacity(0.2),
                        radius: 3, x: 0, y: 2)
            
            VStack(spacing: 6) {
                Image(foodItem.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .shadow(radius: 1)
                    .padding(.top, 15)
                
                Text(foodItem.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isDarkMode ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Text("Expires: \(formattedDate(foodItem.date))")
                    .font(.system(size: 12))
                    .foregroundColor(isDarkMode ? Color.white.opacity(0.85) : .secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                let daysLeft = daysUntilExpiry(for: foodItem.date)
                if daysLeft >= 0 {
                    MiniDaysLeftRing(
                        daysLeft: daysLeft,
                        maxDays: 10,
                        size: 40,
                        lineWidth: 3,
                        isDarkMode: isDarkMode
                    )
                    .padding(.top, 4)
                } else {
                    Text("Expired")
                        .font(.system(size: 12, weight: .bold))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(Color.red.opacity(0.85))
                        .foregroundColor(.white)
                        .cornerRadius(4)
                        .padding(.top, 4)
                }
                
                Spacer(minLength: 4)
            }
            .padding([.horizontal, .bottom], 6)
        }
        .frame(height: 150)
        .onTapGesture {
            showDetails.toggle()
        }
        .sheet(isPresented: $showDetails) {
            FullInventoryCard(foodItem: foodItem, isDarkMode: isDarkMode)
        }
        .contextMenu {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    

    var backgroundGradientColors: [Color] {
        if isDarkMode {
            return [Color.gray.opacity(0.2), Color.purple.opacity(0.2)]
        } else {
            return [Color.white.opacity(0.8), Color.purple.opacity(0.05)]
        }
    }
    
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    func daysUntilExpiry(for date: Date) -> Int {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfExpiry = calendar.startOfDay(for: date)
        
        if let difference = calendar.dateComponents([.day], from: startOfToday, to: startOfExpiry).day {
            return difference
        }
        return -1
    }
}


struct MiniDaysLeftRing: View {
    let daysLeft: Int
    let maxDays: Int
    let size: CGFloat
    let lineWidth: CGFloat
    var isDarkMode: Bool
    
    var fraction: CGFloat {
        guard maxDays > 0 else { return 0 }
        let ratio = CGFloat(daysLeft) / CGFloat(maxDays)
        return ratio > 1 ? 1 : (ratio < 0 ? 0 : ratio)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    (isDarkMode ? Color.white : Color.black).opacity(0.15),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
            
            Circle()
                .trim(from: 0, to: fraction)
                .stroke(
                    ringColor(),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            
            Text("\(daysLeft)d")
                .font(.system(size: 8, weight: .bold))
                .foregroundColor(isDarkMode ? .white : .black)
        }
        .frame(width: size, height: size)
    }
    
    func ringColor() -> Color {
        switch daysLeft {
        case 0...2:
            return .red
        case 3...5:
            return .orange
        default:
            return .green
        }
    }
}

