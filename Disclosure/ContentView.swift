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
    
#if !os(macOS)
    init() {
        UITabBarItem.appearance().badgeColor = .accent
    }
#endif
    
    var body: some View {
#if os(macOS)
        CustomTabView(tabBarPosition: .bottom, content: [
//            ("Journal", "book.pages", AnyView(JournalView())), wip
            ("Team", "person.3", AnyView(TeamView(data: team))), //currently has a lot of problems
            ("Tracker", "chart.line.uptrend.xyaxis", AnyView(TrackerView(data: relapses)))
        ])
        .onAppear {
            if relapses.isEmpty {
                for relapse in TestData.spreadsheet {
                    context.insert(relapse)
                }
            }
            if team.isEmpty {
                for person in TestData.myTeam {
                    context.insert(person)
                }
            }
        }
#else
        TabView {
            JournalView()
                .tabItem { Label("Journal", systemImage: "book.pages") }
            TeamView(data: team)
                .tabItem { Label("Team", systemImage: "person.3") }
                .if((team.min { $0.daysSinceCall ?? Int.max < $1.daysSinceCall ?? Int.max}?.daysSinceCall ?? Int.max) != 0) {
                    $0.badge("Call")
                }
            
            TrackerView(data: relapses)
                .tabItem { Label("Tracker", systemImage: "chart.line.uptrend.xyaxis") }
        }
        .onAppear {
            if relapses.isEmpty {
                for relapse in TestData.spreadsheet {
                    context.insert(relapse)
                }
            }
            if team.isEmpty {
                for person in TestData.myTeam {
                    context.insert(person)
                }
            }
        }
#endif
    }
    
}
