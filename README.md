# ByteWiseCalendar
This is an IOS app that helps users track their food inventory on a calendar. It provides features such as food item tracking, grocery suggestions, expiry reminders, and a waste comparison to encourage efficient use of resources.
## Features
- Interactive Calendar View: Displays food items by date, with drag-and-drop support.
- Camera Integration: Capture photos of food items and add them to the calendar.
- Waste Comparison: Visualizes money saved weekly by reducing food waste.
- Quick Tips: Provides tips for proper food storage and handling.
- Grocery Suggestions: Helps users plan their grocery shopping effectively.
- Undo Support: Recover deleted items seamlessly.
## Screenshots
<table align="center">
  <tr>
    <td>
      <img 
        width="562" 
        alt="Screenshot 2025-01-20 at 3 01 11 PM" 
        src="https://github.com/user-attachments/assets/a450bf43-e217-4ca0-a47e-96e2941f1c14" 
        />
    </td>
    <td style="width: 100px;"></td> 
    <td>
      <img 
        width="564" 
        alt="Screenshot 2025-01-20 at 3 02 06 PM" 
        src="https://github.com/user-attachments/assets/97903059-50d2-48ea-8c06-cba80e43feff" 
        />
    </td>
  </tr>
</table>

## Installation
1. Clone the repository
```
git clone https://github.com/yourusername/FoodCalendarApp.git
cd FoodCalendarApp
```
2. Open the `FoodCalendarApp.xcodeproj` in Xcode.
3. Build and run the app on your simulator or a connected device.
## Code Overview
- `FoodCalendarApp.swift`: Entry point of the application.
- `ContentView.swift`: Main screen with the calendar and other views.
- `CalendarGridView.swift`: Custom grid view for rendering the calendar.
- `CalendarDateCell.swift`: Individual cell components for dates.
- `CameraView.swift`: Enables photo capture using the device camera.
- `FoodItem.swift`: Model representing a food item.

## Technologies Used
- SwiftUI: For building responsive UI.
- UIKit: Camera functionality integration.
- Custom Animations: To improve user experience.

## Video Submission
- The following video shows the key features of the ByteWise App, including interactive calendar navigation, food item management, grocery suggestions, and camera integration.
[ByteWise Link](https://youtu.be/2-h6cwwBjss?si=w_xulkL35c8tVkn9)

## Future Possible Changes
- Push notifications for food expiry reminders.
- Cloud synchronization for multi-device support.
- Advanced analytics for food usage trends.
