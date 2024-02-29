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
    @Query(sort: \Relapse.date, order: .reverse) var data: [Relapse]
    var body: some View {
        TabView {
            TrackerView(data: data)
                .tabItem { Label("Tracker", systemImage: "chart.line.uptrend.xyaxis") }
            Rectangle()
                .fill(.background)
                .tabItem { Label("Team", systemImage: "person.3.sequence") }
        }
        .onAppear {
            if data.isEmpty {
                for relapse in TestData.spreadsheet {
                    context.insert(relapse)
                }
            }
        }
    }
    
}


//#Preview {
//    ContentView()
//}
