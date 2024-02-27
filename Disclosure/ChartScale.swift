//
//  ChartScale.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/27/24.
//

import Foundation

enum ChartScale: String, CaseIterable, Identifiable {
    var id: Self { return self}
    case week = "Week"
    case month = "Month"
    case threeMonth = "3 Months"
    case year = "Year"
    
    var domain: Int {
        switch self {
        case ChartScale.week:
            7
        case ChartScale.month:
            31
        case ChartScale.threeMonth:
            30*3
        case ChartScale.year:
            365
        }
    }
    
    var calendarComponent: Calendar.Component {
        switch self {
        case ChartScale.week:
            Calendar.Component.day
        case ChartScale.month:
            Calendar.Component.day
        case ChartScale.threeMonth:
            Calendar.Component.weekOfMonth
        case ChartScale.year:
            Calendar.Component.month
        }
    }
    
    var timeInterval: TimeInterval {
        TimeInterval(domain * 24 * 60 * 60)
    }
    var startDate: Date {
        Date.now.addingTimeInterval(-1 * self.timeInterval)
    }
    var prevDate: Date {
        Date.now.addingTimeInterval(-2 * self.timeInterval)
    }
}
