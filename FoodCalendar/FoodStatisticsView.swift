import SwiftUI

struct FoodStatisticsView: View {
    let foodItem: FoodItem
    var isDarkMode: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Statistics for \(foodItem.name)")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Image(foodItem.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(radius: 5)
                .accessibilityHidden(true)

            
            List {
                Section(header: Text("Details")) {
                    HStack {
                        Text("Name:")
                        Spacer()
                        Text(foodItem.name)
                    }
                    HStack {
                        Text("Expiry Date:")
                        Spacer()
                        Text(formattedDate(foodItem.date))
                    }                
                }
            }
            .listStyle(InsetGroupedListStyle())

            Spacer()
        }
        .padding()
        .background(isDarkMode ? Color.black : Color.white)
        .navigationTitle("\(foodItem.name) Stats")
        .navigationBarTitleDisplayMode(.inline)
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
