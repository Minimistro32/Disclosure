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
        
    var body: some View {
        TabView {
            TeamView(data: team)
                .tabItem { Label("Team", systemImage: "person.3") }
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
    }
    
}
