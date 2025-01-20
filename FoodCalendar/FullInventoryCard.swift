import SwiftUI

struct FullInventoryCard: View {
    let foodItem: FoodItem
    var isDarkMode: Bool
    
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        ZStack {
            // Background
            if isDarkMode {
                Color.black.edgesIgnoringSafeArea(.all)
            } else {
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple.opacity(0.1), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            }
            
            VStack(spacing: 20) {
                Image(foodItem.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .padding(.top, 20)
                
                Text(foodItem.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(isDarkMode ? .white : .primary)
                
                Text("Expires on \(formattedDate(foodItem.date))")
                    .font(.headline)
                    .foregroundColor(isDarkMode ? .white.opacity(0.8) : .secondary)
                
                let days = daysUntilExpiry(for: foodItem.date)
                if days >= 0 {
                    LargeDaysLeftRing(daysLeft: days, maxDays: 10, isDarkMode: isDarkMode)
                        .frame(width: 100, height: 100)
                        .padding(.vertical, 10)
                } else {
                    Text("This item has expired.")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                
                Text("Storage Suggestions:")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(isDarkMode ? .white : .primary)
                
                Text(storageTips(for: foodItem.name))
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(isDarkMode ? .white.opacity(0.9) : .black.opacity(0.8))
                    .padding(.horizontal, 30)

                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 120)
                        .background(Color.purple)
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)
            }
        }
    }
    
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
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
    
    // Return some sample text suggestions for item
    func storageTips(for name: String) -> String {
        switch name.lowercased() {
        case "apple":
            return "Store apples separately from bananas to prevent over-ripening. Keep them in a cool place."
        case "chicken":
            return "Keep chicken in the coldest part of your fridge and use within 1-2 days of purchase."
        case "milk":
            return "Store milk on the middle shelf to maintain a consistent temperature."
        case "carrot":
            return "Keep carrots in a perforated plastic bag in the fridge to retain moisture."
        case "banana":
            return "Bananas can be stored at room temperature until they reach desired ripeness."
        default:
            return "Keep in a cool, dry place or refrigerator depending on the item."
        }
    }
}

// MARK: - Large DaysLeftRing
struct LargeDaysLeftRing: View {
    let daysLeft: Int
    let maxDays: Int
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
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
            
            Circle()
                .trim(from: 0, to: fraction)
                .stroke(
                    ringColor(),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            
            Text("\(daysLeft) days")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(isDarkMode ? .white : .black)
        }
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
