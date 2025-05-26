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
            Int(Date.monthsAgoSunday(count: 1).timeIntervalSinceNow / -89600)
        case ChartScale.threeMonth:
            Int(Date.monthsAgoThe1st(count: 2).timeIntervalSinceNow / -89600)
        case ChartScale.year:
            365
        }
    }
    
    var calendarUnit: Calendar.Component {
        switch self {
        case ChartScale.week:
            Calendar.Component.weekday
        case ChartScale.month:
            Calendar.Component.weekOfYear
        case ChartScale.threeMonth:
            Calendar.Component.month
        case ChartScale.year:
            Calendar.Component.month
        }
    }
    
    var timeInterval: TimeInterval {
        TimeInterval(domain * 24 * 60 * 60)
    }
     
    func containsDate(_ date: Date?) -> Bool {
        guard let date else { return false }
        
        let endDate = switch self {
        case .week:
            Date.now.endOfDay
        case .month:
            Date.now.endOfWeek
        default:
            Date.now.endOfMonth
        }
        
        return date >= startDate && date <= (endDate ?? Date.now)
    }
    
    var startDate: Date {
        switch self {
        case .week:
            return Date.now.addingTimeInterval(-timeInterval).startOfWeek
        case .month:
            return Date.monthsAgoSunday(count: 1)
        case .threeMonth:
            return Date.monthsAgoThe1st(count: 2)
        case .year:
            return Date.now.addingTimeInterval(-timeInterval).startOfMonth
        }
    }
}
