//
//  ChartScale.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/27/24.
//

import Foundation

enum ChartScale: String, CaseIterable, Identifiable {
    var id: Self { return self }
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
    
    var timeInterval: TimeInterval {
        TimeInterval(domain * 24 * 60 * 60)
    }
    
    var calendarUnit: Calendar.Component {
        switch self {
        case .week: .day
        case .month: .weekOfYear
        case .threeMonth, .year: .month
        }
    }

    func containsDate(_ date: Date?) -> Bool {
        guard let date else { return false }
        return date >= startDate && date < endDate
    }

    var startDate: Date { startDate(relativeTo: .now, calendar: .current) }
    var endDate: Date { endDate(relativeTo: .now, calendar: .current) }

    private func startDate(relativeTo reference: Date, calendar: Calendar) -> Date {
        switch self {
        case .week:
            return calendar.dateInterval(of: .weekOfYear, for: reference)!.start
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: reference)!
            return calendar.dateInterval(of: .weekOfYear, for: monthAgo)!.start
        case .threeMonth, .year:
            let monthStart = calendar.dateInterval(of: .month, for: reference)!.start
            return calendar.date(byAdding: .month, value: self == .threeMonth ? -2 : -11, to: monthStart)!
        }
    }

    private func endDate(relativeTo reference: Date, calendar: Calendar) -> Date {
        let interval: Calendar.Component = self == .week || self == .month ? .weekOfYear : .month
        return calendar.dateInterval(of: interval, for: reference)!.end
    }

    private func bucketCount(relativeTo reference: Date, calendar: Calendar) -> Int {
        switch self {
        case .week: return 7
        case .threeMonth: return 3
        case .year: return 12
        case .month:
            return calendar.dateComponents(
                [.weekOfYear],
                from: startDate(relativeTo: reference, calendar: calendar),
                to: endDate(relativeTo: reference, calendar: calendar)
            ).weekOfYear!
        }
    }

    // Snap to bucket starts before shifting so short months and clock changes
    // cannot make the prior and current buckets map to different positions.
    private func shiftedBucket(_ date: Date, direction: Int, relativeTo reference: Date, calendar: Calendar) -> Date {
        let bucketStart = calendar.dateInterval(of: calendarUnit, for: date)!.start
        let count = bucketCount(relativeTo: reference, calendar: calendar)
        return calendar.date(byAdding: calendarUnit, value: direction * count, to: bucketStart)!
    }

    func previousDate(_ date: Date, relativeTo reference: Date = .now, calendar: Calendar = .current) -> Date {
        shiftedBucket(date, direction: -1, relativeTo: reference, calendar: calendar)
    }

    func nextDate(_ date: Date, relativeTo reference: Date = .now, calendar: Calendar = .current) -> Date {
        shiftedBucket(date, direction: 1, relativeTo: reference, calendar: calendar)
    }

    func isSameBucket(_ first: Date, as second: Date) -> Bool {
        Calendar.current.isDate(first, equalTo: second, toGranularity: calendarUnit)
    }
}
