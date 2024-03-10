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
    @Query(sort: [SortDescriptor(\Person.sortValue), SortDescriptor(\Person.checkInDate)]) var team: [Person]
    
    init() {
        UITabBarItem.appearance().badgeColor = .accent
    }
    
    var body: some View {
        TabView {
            TeamView(data: team)
                .tabItem { Label("Team", systemImage: "person.3") }
                .if(!(team.first?.checkInDate?.isSame(as: Date.now, unit: .day) ?? false)) {
                    $0.badge(1)
                }
            
            TrackerView(data: relapses)
                .tabItem { Label("Tracker", systemImage: "chart.line.uptrend.xyaxis") }
                .if(relapses.contains(where: { $0.reminder })) {
                    $0.badge(relapses.filter { $0.reminder }.count)
                }
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
    }
    
}
