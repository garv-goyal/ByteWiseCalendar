import SwiftUI

struct SettingsView: View {
    @Binding var isDarkMode: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $isDarkMode) {
                        HStack {
                            Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                                .foregroundColor(isDarkMode ? .yellow : .orange)
                            Text("Dark Mode")
                        }
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("App Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Developer")
                        Spacer()
                        Text("Your Name")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Settings")
            .background(isDarkMode ? Color.black.opacity(0.05) : Color.white)
        }
        .accentColor(.purple)
    }
}

