import SwiftUI

struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.purple)
            .padding(.horizontal, 16)
    }
}


struct NotificationSettingsView: View {
    var body: some View {
        VStack {
            Text("Notification Settings")
                .font(.title)
                .padding()
            
            // notification setting to implement
            
            Spacer()
        }
    }
}


struct PrivacyPolicyView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Privacy Policy")
                .font(.title)
                .padding()
            
            ScrollView {
                Text("""
                Privacy Policy Content Here...
                """)
                .padding()
            }
            
            Spacer()
        }
    }
}


struct TermsOfServiceView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Terms of Service")
                .font(.title)
                .padding()
            
            ScrollView {
                Text("""
                Terms of Service Content Here...
                """)
                .padding()
            }
            
            Spacer()
        }
    }
}


struct FAQView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Frequently Asked Questions")
                .font(.title)
                .padding()
            
            ScrollView {
                Text("""
                FAQ Content Here...
                """)
                .padding()
            }
            
            Spacer()
        }
    }
}


struct SettingsView: View {
    @Binding var isDarkMode: Bool
    
    @State private var showNotificationSettings = false
    @State private var showPrivacyPolicy = false
    @State private var showTermsOfService = false
    @State private var showFAQ = false
    @State private var showClearDataAlert = false
    
    @State private var notificationsEnabled: Bool = true
    
    func contactSupport() {
        if let url = URL(string: "mailto:support@garv.goyal213.com") {
            UIApplication.shared.open(url)
        }
    }
    
    func importData() {
        // to implement
        print("Import Data tapped")
    }
    
    func exportData() {
        // to implement
        print("Export Data tapped")
    }
    
    func clearAllData() {
        // to implement
        print("Clear All Data tapped")
    }
    
    
    var body: some View {
        VStack(spacing: 2) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: isDarkMode
                                       ? [Color.purple.opacity(0.5), Color.blue.opacity(0.3)]
                                       : [Color.purple.opacity(0.1), Color.purple.opacity(0.0)]
                                      ),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: 775, height: 200)
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding()
                .padding([.leading, .bottom, .trailing], 16)
                
                VStack(alignment: .center, spacing: 10) {
                    Image(systemName: "calendar.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(isDarkMode ? Color.purple : Color.purple.opacity(1.5))
                        .shadow(radius: 5)
                        .padding(.trailing, -30)
                    
                    Text("Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(isDarkMode ? Color.white : Color.black)
                        .padding(.trailing, -30)
                    
                    Text("Manage your food items and reduce waste effortlessly.")
                        .font(.subheadline)
                        .foregroundColor(isDarkMode ? Color.white.opacity(0.7) : Color.black.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.leading, 16)
                        .padding(.trailing, -15)
                }
                .padding(.bottom, 30)
                .padding(.trailing, 30)
            }
            .padding(.top, 5)
            .padding(.bottom, -15)
            .padding(.trailing, 15)
            
            Divider()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    SectionHeader(title: "Appearance")
                    Toggle(isOn: $isDarkMode) {
                        HStack {
                            Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                                .foregroundColor(isDarkMode ? .yellow : .orange)
                            Text("Dark Mode")
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .purple))
                    .padding(.horizontal, 16)
                    
                    SectionHeader(title: "Notifications")
                    Toggle(isOn: $notificationsEnabled) {
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.blue)
                            Text("Enable Notifications")
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .purple))
                    .padding(.horizontal, 16)
                    
                    Button(action: {
                        showNotificationSettings = true
                    }) {
                        HStack {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(.blue)
                            Text("Notification Settings")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(isDarkMode ? Color(UIColor.systemGray5) : Color.purple.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .sheet(isPresented: $showNotificationSettings) {
                        NotificationSettingsView()
                            .environment(\.colorScheme, isDarkMode ? .dark : .light)
                    }
                    
                    SectionHeader(title: "Data Management")
                    Button(action: exportData) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.green)
                            Text("Export Data")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(isDarkMode ? Color(UIColor.systemGray5) : Color.purple.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    Button(action: importData) {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                                .foregroundColor(.green)
                            Text("Import Data")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(isDarkMode ? Color(UIColor.systemGray5) : Color.purple.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        showClearDataAlert = true
                    }) {
                        HStack {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                            Text("Clear All Data")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.red.opacity(0.0))
                        .cornerRadius(10)
                    }
                    .alert(isPresented: $showClearDataAlert) {
                        Alert(
                            title: Text("Clear All Data"),
                            message: Text("Are you sure you want to delete all your data? This action cannot be undone."),
                            primaryButton: .destructive(Text("Delete")) {
                                clearAllData()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    
                    SectionHeader(title: "Privacy")
                    Button(action: {
                        showPrivacyPolicy = true
                    }) {
                        HStack {
                            Image(systemName: "lock.shield")
                                .foregroundColor(.purple)
                            Text("Privacy Policy")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(isDarkMode ? Color(UIColor.systemGray5) : Color.purple.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .sheet(isPresented: $showPrivacyPolicy) {
                        PrivacyPolicyView()
                            .environment(\.colorScheme, isDarkMode ? .dark : .light)
                    }
                    
                    Button(action: {
                        showTermsOfService = true
                    }) {
                        HStack {
                            Image(systemName: "doc.text.magnifyingglass")
                                .foregroundColor(.purple)
                            Text("Terms of Service")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(isDarkMode ? Color(UIColor.systemGray5) : Color.purple.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .sheet(isPresented: $showTermsOfService) {
                        TermsOfServiceView()
                            .environment(\.colorScheme, isDarkMode ? .dark : .light)
                    }
                    
                    SectionHeader(title: "Help & Support")
                    
                    Button(action: {
                        showFAQ = true
                    }) {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundColor(.orange)
                            Text("FAQ")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(isDarkMode ? Color(UIColor.systemGray5) : Color.purple.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .sheet(isPresented: $showFAQ) {
                        FAQView()
                            .environment(\.colorScheme, isDarkMode ? .dark : .light)
                    }
                    
                    Button(action: contactSupport) {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.orange)
                            Text("Contact Support")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(isDarkMode ? Color(UIColor.systemGray5) : Color.purple.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    SectionHeader(title: "About")
                    
                    HStack {
                        Text("App Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 16)
                    
                    HStack {
                        Text("Developer")
                        Spacer()
                        Text("Garv Goyal")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 16)
                    
                    HStack {
                        Text("License")
                        Spacer()
                        Text("MIT License")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 20)
                .padding(.leading, 5)
            }
            .padding(.top, 10)
            .padding(.trailing, 25)
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
        .background(isDarkMode ? Color.black : Color.purple.opacity(0.1))
        .padding(.leading, 20)
    }
}
