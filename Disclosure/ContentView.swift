//
//  ContentView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 1/29/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \Relapse.date, order: .reverse) var relapses: [Relapse]
    @Query(sort: [SortDescriptor(\Person.sortValue), SortDescriptor(\Person.latestCall)]) var team: [Person]
    @Query(sort: \Entry.date, order: .reverse) var entries: [Entry]
    
#if !os(macOS)
    init() {
        UITabBarItem.appearance().badgeColor = .accent
    }
#endif
    
    @ViewBuilder
    private var PlatformManagedTabView: some View {
#if os(macOS)
        CustomTabView(tabBarPosition: .top, content: [
            ("Journal", "book.pages", AnyView(JournalView(relapses: relapses, entries: entries))),
            ("Tracker", "chart.line.uptrend.xyaxis", AnyView(TrackerView(data: relapses))),
            ("Team", "person.3", AnyView(TeamView(data: team)))
        ])
#else
        TabView {
            JournalView(relapses: relapses, entries: entries)
                .tabItem { Label("Journal", systemImage: "book.pages") }
            TeamView(data: team)
                .tabItem { Label("Team", systemImage: "person.3") }
                .if((team.min { $0.daysSinceCall ?? Int.max < $1.daysSinceCall ?? Int.max}?.daysSinceCall ?? Int.max) != 0) {
                    $0.badge("Call")
                }
            
            TrackerView(data: relapses)
                .tabItem { Label("Tracker", systemImage: "chart.line.uptrend.xyaxis") }
        }
#endif
    }
    
    var body: some View {
        PlatformManagedTabView
            .onAppear {
                if DisclosureApp.RELOAD_MODEL || relapses.isEmpty || team.isEmpty {
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
                        print("Failed to delete relapses.")
                    }
                    for person in TestData.myTeam {
                        context.insert(person)
                    }
                }
            }
    }
    
}
