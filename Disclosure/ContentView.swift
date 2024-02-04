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
            TrackerView(rawSelectedDate: .constant(nil))
                .tabItem { Label("Tracker", systemImage: "chart.line.uptrend.xyaxis") }
        }
    }
}


#Preview {
    ContentView()
}


// MARK: - Extensions
extension Date {
    static func from(year: Int, month: Int, day: Int, hour: Int? = nil, minute: Int? = nil) -> Date {
        let components = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
        return Calendar.current.date(from:components)!
    }
}
