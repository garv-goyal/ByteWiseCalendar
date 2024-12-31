import SwiftUI

struct CalendarGridView: View {
    @Binding var selectedDate: Date
    @Binding var foodItems: [FoodItem]
    @State private var deletedItems: [FoodItem] = [] // Stack to track all deleted items
    @State private var showCamera = false // Track when to show the camera
    @State private var capturedImage: UIImage? // Store the captured image

    let columns = Array(repeating: GridItem(.flexible(), spacing: 5), count: 7)
    let dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Day Names Header with Purple Background
                HStack(spacing: 6.5) {
                    ForEach(dayNames, id: \.self) { day in
                        Text(day)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: (geometry.size.width / 7) - 6, height: 20)
                            .background(Color.purple.opacity(0.9))
                            .cornerRadius(5)
                    }
                }
                .padding(.bottom, 4)
                .padding(.trailing, 2)
                .padding(.leading, 2)

                // Calendar Grid
                LazyVGrid(columns: columns, spacing: 5) {
                    // Previous Month Dates
                    ForEach(generatePreviousMonthDates(), id: \.self) { date in
                        CalendarDateCell(date: date, foodItems: .constant([]), isNextMonthDate: true)
                            .frame(width: (geometry.size.width / 7) - 6, height: (geometry.size.width / 7) * 1.26)
                            .background(Color.purple.opacity(0.1))
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                    }

                    // Current Month Dates
                    ForEach(generateDates(), id: \.self) { date in
                        CalendarDateCell(date: date, foodItems: $foodItems, isNextMonthDate: false)
                            .frame(width: (geometry.size.width / 7) - 6, height: (geometry.size.width / 7) * 1.26)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                    }
                }
                .padding(.trailing, 2)
                .padding(.leading, 2)
            

                // Bottom Section with "Nov 24" and Undo, Trash, Camera, and New Delete Button
                HStack(spacing: 3) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.purple.opacity(0.3))
                            .frame(width: 320, height: 89) // Same size as the buttons
                        
                        Text(monthYearString(from: selectedDate))
                            .font(.system(size: 63, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    .padding(.leading, 10)
                    .padding(.bottom, 10)

                    Spacer()

                    HStack(spacing: 10) {
                        
                        // New Delete Button with Same Functionality as Trash
                        VStack {
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.purple.opacity(0.3))
                                    .frame(width: 100, height: 89)

                                Image("pacman")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 95, height: 68)
                                    .foregroundColor(.black)
                                    .padding(5)
                                    .onDrop(of: [.text], isTargeted: nil) { providers in
                                        handleDrop(providers: providers)
                                    }
                            }
                            Spacer()
                                .padding(.bottom, 10)
                        }
                        
                        // Undo Button
                        VStack {
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.purple.opacity(0.3))
                                    .frame(width: 100, height: 89)

                                Image(systemName: "arrow.uturn.backward")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 95, height: 68)
                                    .foregroundColor(.black)
                                    .padding(5)
                            }
                            .onTapGesture {
                                undoDelete()
                            }
                            .disabled(deletedItems.isEmpty)
                            .opacity(deletedItems.isEmpty ? 0.5 : 1.0)
                            Spacer()
                                .padding(.bottom, 10)
                        }

                        // Trash Button
                        VStack {
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.purple.opacity(0.3))
                                    .frame(width: 100, height: 89)

                                Image(systemName: "trash")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 95, height: 68)
                                    .foregroundColor(.black)
                                    .padding(5)
                                    .onDrop(of: [.text], isTargeted: nil) { providers in
                                        handleDrop(providers: providers)
                                    }
                            }
                            Spacer()
                                .padding(.bottom, 10)
                        }

                        // Camera Button
                        VStack {
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.purple.opacity(0.3))
                                    .frame(width: 100, height: 89)

                                Image(systemName: "camera")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 95, height: 68)
                                    .foregroundColor(.black)
                                    .padding(5)
                                    .onTapGesture {
                                        showCamera = true
                                    }
                            }
                            Spacer()
                                .padding(.bottom, 10)
                        }
                    }
                    .padding(.trailing, 10)
                }
                .frame(height: 120)
                .sheet(isPresented: $showCamera) {
                    CameraView(isPresented: $showCamera, image: $capturedImage)
                }
            }
        }
    }

    // Helper Function to Format Month and Year as "Nov 24"
    func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM YYYY" // e.g., "Nov 24"
        return formatter.string(from: date)
    }

    // Generate Previous Month Dates for the Calendar
    func generatePreviousMonthDates() -> [Date] {
        var previousMonthDates: [Date] = []
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))!
        let previousMonth = calendar.date(byAdding: .month, value: -1, to: startOfMonth)!
        let range = calendar.range(of: .day, in: .month, for: previousMonth)!

        // Get the last few days of the previous month to fill the first week
        let numberOfDaysToShow = 5
        let startDay = range.count - numberOfDaysToShow + 1

        for day in startDay...range.count {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: previousMonth) {
                previousMonthDates.append(date)
            }
        }
        return previousMonthDates
    }

    // Generate Current Month Dates for the Calendar
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

    // Handle Drop Action for Trash Button
    func handleDrop(providers: [NSItemProvider]) -> Bool {
        for provider in providers {
            if provider.canLoadObject(ofClass: NSString.self) {
                _ = provider.loadObject(ofClass: NSString.self) { object, error in
                    if let imageName = object as? String {
                        DispatchQueue.main.async {
                            if let itemToDelete = foodItems.first(where: { $0.imageName == imageName }) {
                                deletedItems.append(itemToDelete) // Store the deleted item in the stack
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

    // Undo the Last Deleted Item
    func undoDelete() {
        if let lastItem = deletedItems.popLast() {
            foodItems.append(lastItem)
        }
    }
}
