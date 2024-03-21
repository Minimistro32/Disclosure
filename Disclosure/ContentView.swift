//
//  ContentView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 1/29/24.
//

import SwiftUI
import SwiftData
import UserNotifications

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Relapse.date, order: .reverse) private var relapses: [Relapse]
    @Query(sort: [SortDescriptor(\Person.sortValue), SortDescriptor(\Person.latestCall)]) private var team: [Person]
    @Query(sort: \Entry.date, order: .reverse) private var entries: [Entry]
    @Query private var _settings: [Settings]
    private var settings: Settings {
        var s = _settings.first
        if s == nil {
            s = Settings()
            context.insert(s!)
        }
        return s!
    }
    var appIsActivePublisher = NotificationCenter.default
            .publisher(for: UIApplication.willEnterForegroundNotification)
    
    func setBadge() {
        let callBadge = Int(settings.callBadge && (team.min { $0.daysSinceCall ?? Int.max < $1.daysSinceCall ?? Int.max}?.daysSinceCall ?? Int.max) != 0)
        let analyzeBadges = settings.analyzeBadges ? relapses.filter { $0.reminder }.count : 0
        UNUserNotificationCenter.current().setBadgeCount(analyzeBadges + callBadge)
    }
    
#if !os(macOS)
    init() {
        UITabBarItem.appearance().badgeColor = .accent
    }
#endif
    
    @ViewBuilder
    private var PlatformManagedTabView: some View {
#if os(macOS)
        CustomTabView(tabBarPosition: .top, content: [
            ("Team", "person.3", AnyView(TeamView(data: team))),
            ("Tracker", "chart.line.uptrend.xyaxis", AnyView(TrackerView(data: relapses))),
            ("Journal", "book.pages", AnyView(JournalView(relapses: relapses, entries: entries)))
        ])
#else
        TabView {
            TeamView(data: team)
                .tabItem { Label("Team", systemImage: "person.3") }
                .if(settings.callBadge && (team.min { $0.daysSinceCall ?? Int.max < $1.daysSinceCall ?? Int.max}?.daysSinceCall ?? Int.max) != 0) {
                    $0.badge("Call")
                }
            TrackerView(data: relapses)
                .tabItem { Label("Tracker", systemImage: "chart.line.uptrend.xyaxis") }
            JournalView(relapses: relapses, entries: entries)
                .tabItem { Label("Journal", systemImage: "book.pages") }
//            Rectangle().fill(.indigo)
//                .tabItem { Label("Practice", systemImage: "brain.fill") }
            SettingsView(settings: settings)
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
#endif
    }
    
    var body: some View {
        PlatformManagedTabView
            .onAppear {
                setBadge()
            }
            .onReceive(appIsActivePublisher) { _ in
                setBadge()
            }
            .onAppear {
                if DisclosureApp.RELOAD_MODEL || relapses.isEmpty || team.isEmpty || entries.isEmpty {
                    do {
                        try context.delete(model: Relapse.self)
                    } catch {
                        print("Failed to delete relapses.")
                    }
                    for relapse in TestData.spreadsheet {
                        context.insert(relapse)
                    }
                    do {
                        try context.delete(model: Person.self)
                    } catch {
                        print("Failed to delete people.")
                    }
                    for person in TestData.myTeam {
                        context.insert(person)
                    }
                    do {
                        try context.delete(model: Entry.self)
                    } catch {
                        print("Failed to delete entries.")
                    }
                    for entry in TestData.journal {
                        context.insert(entry)
                    }
                }
            }
    }
    
}
