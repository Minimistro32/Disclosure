//
//  SettingsView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/21/24.
//

import SwiftUI
import SwiftData
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
    
    //MARK: - Data Management
    @Environment(\.modelContext) var context
    let relapses: [Relapse]
    let entries: [Entry]
    
    @State private var managedData: String = "Disclosure"
    @State private var csv: CSV?
    
    @State private var isImporting: Bool = false
    @State private var isExporting: Bool = false
    @State private var confirmSample: Bool = false
    @State private var confirmImport: Bool = false
    @State private var confirmExport: Bool = false
    @State private var confirmDelete: Bool = false
    
    @State private var errorAlert: String?
    
    var dataManagementSection: some View {
        Section {
            Button("Download Sample", systemImage: "arrow.down.doc") { confirmSample = true }
                .confirmationDialog("What would you like to download a sample for?", isPresented: $confirmSample, titleVisibility: .visible) {
                    Button("Relapse Data") {
                        managedData = "SampleRelapse"
                        csv = CSV(SampleData.relapses.reduce(Relapse.csvHeader()) { $0 + $1.csvLine() })
                        isExporting = true
                    }
                    Button("Journal Data") {
                        managedData = "SampleJournal"
                        csv = CSV(SampleData.entries.reduce(Entry.csvHeader()) { $0 + $1.csvLine() })
                        isExporting = true
                    }
                    Button("Cancel", role: .cancel) {}
                }
                .fileExporter(
                    isPresented: $isExporting,
                    document: csv,
                    contentType: .commaSeparatedText,
                    defaultFilename: "\(managedData)Export.csv"
                ) { result in
                    if case .failure(let error) = result {
                        errorAlert = error.localizedDescription
                    }
                }
            
            Button("Import Data via CSV", systemImage: "square.and.arrow.down") { confirmImport = true }
                .confirmationDialog("What would you like to import? This will insert data alongside anything already saved in the app.", isPresented: $confirmImport, titleVisibility: .visible) {
                    Button("Relapse Data") {
                        managedData = "Relapse"
                        isImporting = true
                    }
                    Button("Journal Data") {
                        managedData = "Journal"
                        isImporting = true
                    }
                    Button("Cancel", role: .cancel) {}
                }
                .fileImporter(
                    isPresented: $isImporting,
                    allowedContentTypes: [.commaSeparatedText],
                    allowsMultipleSelection: false
                ) { result in
                    switch result {
                    case .success(let urls):
                        guard let file = urls.first else { return }
                        let gotAccess = file.startAccessingSecurityScopedResource()
                        if !gotAccess { return }
                        
                        do {
                            let contents = try String(contentsOf: file, encoding: .utf8)
                            
                            let lines = CSV.parse(file: contents)
                            for (i, line) in lines.enumerated() {
                                let model: any PersistentModel
                                if managedData == "Relapse" {
                                    guard let relapse = Relapse(csvLine: line) else {
                                        errorAlert = (errorAlert ?? "") + "\nLine \(i + 1) could not be parsed."
                                        continue
                                    }
                                    model = relapse
                                } else {
                                    guard let entry = Entry(csvLine: line) else {
                                        errorAlert = (errorAlert ?? "") + "\nLine \(i + 1) could not be parsed."
                                        continue
                                    }
                                    model = entry
                                }
                                context.insert(model)
                            }
                        } catch {
                            errorAlert = "Could not read contents of file \(file.lastPathComponent)."
                            return
                        }
                        
                        file.stopAccessingSecurityScopedResource()
                    case .failure(let error):
                        errorAlert = error.localizedDescription
                    }
                }
                        
            Button("Export Data as CSV", systemImage: "square.and.arrow.up") { confirmExport = true }
                .confirmationDialog("What would you like to export?", isPresented: $confirmExport, titleVisibility: .visible) {
                    Button("Relapse Data") {
                        managedData = "Relapse"
                        csv = CSV(relapses.reduce(Relapse.csvHeader()) { $0 + $1.csvLine() })
                        isExporting = true
                    }
                    Button("Journal Data") {
                        managedData = "Journal"
                        csv = CSV(entries.reduce(Entry.csvHeader()) { $0 + $1.csvLine() })
                        isExporting = true
                    }
                    Button("Cancel", role: .cancel) {}
                }
                .fileExporter(
                    isPresented: $isExporting,
                    document: csv,
                    contentType: .commaSeparatedText,
                    defaultFilename: "\(managedData)Export.csv"
                ) { result in
                    if case .failure(let error) = result {
                        errorAlert = error.localizedDescription
                    }
                }
        
            Button("Delete All Data", systemImage: "trash", role: .destructive) { confirmDelete = true }
                .foregroundStyle(.red)
                .confirmationDialog("Are you sure you want to delete all data?", isPresented: $confirmDelete, titleVisibility: .visible) {
                    Button("Delete Everything", role: .destructive) {
                        do {
                            try context.delete(model: Entry.self)
                        } catch {
                            errorAlert = (errorAlert ?? "") + "Failed to delete journal data.\n"
                        }
                        
                        do {
                            try context.delete(model: Relapse.self)
                        } catch {
                            errorAlert = (errorAlert ?? "") + "Failed to delete relapse data.\n"
                        }
                        
                        do {
                            try context.delete(model: Person.self)
                        } catch {
                            errorAlert = (errorAlert ?? "") + "Failed to delete recovery team data.\n"
                        }
                        
                        do {
                            try context.save()
                        } catch {
                            errorAlert = (errorAlert ?? "") + "Failed to save changes.\n"
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                }
        } header: {
            Text("Data Management")
        } footer: {
            Text("This will irrecoverably erase all recovery team, relapse, and journal data.")
        }
        .alert("Data Error", isPresented: Binding(
            get: { errorAlert != nil },
            set: { if !$0 { errorAlert = nil } }
        )) {
            Button("Okay") { errorAlert = nil }
        } message: {
            Text("There was an error handling the data. " + (errorAlert ?? ""))
        }

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
                
                dataManagementSection
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

#Preview {
    SettingsView(settings: Settings(), relapses: [], entries: [] )
}
