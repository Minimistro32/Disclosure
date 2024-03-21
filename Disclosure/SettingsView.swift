//
//  SettingsView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/21/24.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @Bindable var settings: Settings
    @State private var permission: Bool?
    var appIsActivePublisher = NotificationCenter.default
            .publisher(for: UIApplication.willEnterForegroundNotification)
    @State private var alertPermission: Bool?
    @State private var badgePermission: Bool?
    private var alertPermissionGranted: Bool { alertPermission ?? true }
    private var badgePermissionGranted: Bool { badgePermission ?? true }
    
    private func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                permission = true
                scheduleNotification()
            } else if let error = error {
                print(error.localizedDescription)
            } else {
                permission = false
            }
        }
    }
    
    private func updateNotificationPermissions() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined {
                requestPermissions()
                return
            }
            if settings.authorizationStatus == .authorized {
                permission = true
            }
            if settings.authorizationStatus == .denied {
                permission = false
            }
            alertPermission = (settings.alertSetting == .enabled)
            badgePermission = (settings.badgeSetting == .enabled)
        }
    }
    
    private func scheduleNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Time to Call"
        notificationContent.body = "Don't forget to tune in 👍"

        var hourAndMinute = DateComponents()
        hourAndMinute.hour = Calendar.current.component(.hour, from: settings.callReminderTime)
        hourAndMinute.minute = Calendar.current.component(.minute, from: settings.callReminderTime)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: hourAndMinute, repeats: true) //UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let req = UNNotificationRequest(identifier: "callReminder", content: notificationContent, trigger: trigger)

        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["callReminder"])
        UNUserNotificationCenter.current().add(req)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                if !badgePermissionGranted || !alertPermissionGranted {
                    Section((!badgePermissionGranted && !alertPermissionGranted ? "" : (!badgePermissionGranted ? "Badge ": "Alert ")) + "Notifications are Disabled") {
                        LabeledContent {
                            Text("1. Settings\n2. Disclosure\n3. Notifications\n4. Allow Notifications")
                        } label: {
                            Text("Instructions")
                        }

                    }
                }
                
                Section("Recovery Team") {
                    Toggle("Daily Call Badge", isOn: $settings.callBadge)
                        .disabled(!badgePermissionGranted)
                    Toggle("Daily Call Reminders", isOn: $settings.callReminders)
                        .disabled(!alertPermissionGranted)
                        .onChange(of: settings.callReminders) { oldValue, newValue in
                            if alertPermissionGranted && newValue {
                                scheduleNotification()
                            }
                        }
                    if settings.callReminders {
                        DatePicker("Check-In Time", selection: $settings.callReminderTime, displayedComponents: .hourAndMinute)
                            .onChange(of: settings.callReminderTime) { oldValue, newValue in
                                if alertPermissionGranted && settings.callReminders {
                                    scheduleNotification()
                                }
                            }
                    }
                    Toggle("Animated Call Suggestions", isOn: $settings.animatedCallSuggestions)
                }
                Section("Recovery Tracker") {
                    Toggle("Analyze Relapse Badges", isOn: $settings.analyzeBadges)
                        .disabled(!badgePermissionGranted)
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                updateNotificationPermissions()
            }
            .onReceive(appIsActivePublisher) { _ in
                updateNotificationPermissions()
            }
            .onChange(of: permission, initial: true) { oldValue, newValue in
                if let newValue = newValue { //for the first time
                    if newValue == false { //permission set to false
                        //adjust settings accordingly
                        settings.callBadge = false
                        settings.callReminders = false
                        settings.analyzeBadges = false
                        
                        alertPermission = false
                        badgePermission = false
                    }
                }
            }
            .onChange(of: badgePermission, initial: true) { oldValue, newValue in
                if let newValue = newValue { //for the first time
                    if newValue == false {
                        settings.callBadge = false
                        settings.analyzeBadges = false
                    }
                }
            }
            .onChange(of: alertPermission, initial: true) { oldValue, newValue in
                if let newValue = newValue { //for the first time
                    if newValue == false {
                        settings.callReminders = false
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView(settings: Settings())
}
