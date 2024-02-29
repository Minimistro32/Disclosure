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
    
    func calendarUnit(for lens: ChartLens) -> Calendar.Component {
        switch self {
        case ChartScale.week:
            Calendar.Component.weekday
        case ChartScale.month:
            Calendar.Component.weekOfMonth
//            lens == .previous ? Calendar.Component.weekOfMonth : Calendar.Component.day
        case ChartScale.threeMonth:
            Calendar.Component.month
//            lens == .previous ? Calendar.Component.month : Calendar.Component.weekOfMonth
        case ChartScale.year:
            Calendar.Component.month
        }
    }
    
    func formatDate(_ date: Date, for lens: ChartLens) -> String {
        if lens == .previous {
            return switch self {
            case ChartScale.week:
                date.formatted(.dateTime.weekday(.wide))
            case ChartScale.month:
                "Week " + date.formatted(.dateTime.week(.weekOfMonth))
            case ChartScale.threeMonth:
                "Month \(3 + Int(date.timeIntervalSinceNow / ChartScale.month.timeInterval))"
            case ChartScale.year:
                date.formatted(.dateTime.month(.wide))
            }
        } else {
            return switch self {
            case ChartScale.week:
                date.formatted(.dateTime.weekday(.wide).day())
            case ChartScale.month:
                "Week " + date.formatted(.dateTime.week(.weekOfMonth))
//                date.formatted(.dateTime.weekday(.wide).month().day())
            case ChartScale.threeMonth:
                date.formatted(.dateTime.month(.wide))
//                date.formatted(.dateTime.month()) + ", Week " + date.formatted(.dateTime.week(.weekOfMonth))
            case ChartScale.year:
                date.formatted(.dateTime.month(.wide).year())
            }
        }
    }
    
    func subtitle(date: Date, for lens: ChartLens) -> String {
        return switch self {
        case ChartScale.week:
            (self.containsDate(date) ? "This" : "Last") + " Week"
        case ChartScale.year:
            (self.containsDate(date) ? "This" : "Last") + " Year"
//            date.formatted(.dateTime.year())
        default:
            date.formatted(.dateTime.month(.wide))
        }
    }
    
    var timeInterval: TimeInterval {
        TimeInterval(domain * 24 * 60 * 60)
    }
     
    func containsDate(_ date: Date) -> Bool {
        return date >= startDate
    }
    
    var startDate: Date {
        Date.now.addingTimeInterval(-timeInterval)
    }
    
    var previousDate: Date {
        Date.now.addingTimeInterval(-2 * timeInterval)
    }
}
