//
//  SettingsView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/21/24.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Bindable var settings: Settings
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Recovery Team") {
                    Toggle("Daily Call Badge", isOn: $settings.callBadge)
                    Toggle("Daily Call Reminders", isOn: $settings.callReminders)
                    if settings.callReminders {
                        DatePicker("Check-In Time", selection: $settings.callReminderTime, displayedComponents: .hourAndMinute)
                    }
                    Toggle("Animated Call Suggestions", isOn: $settings.animatedCallSuggestions)
                }
                Section("Recovery Tracker") {
                    Toggle("Analyze Relapse Badges", isOn: $settings.analyzeBadges)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView(settings: Settings())
}
