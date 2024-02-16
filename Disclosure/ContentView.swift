//
//  ContentView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 1/29/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TrackerView()
                .tabItem { Label("Tracker", systemImage: "chart.line.uptrend.xyaxis") }
        }
    }
}


#Preview {
    ContentView()
}
