//
//  Helpers.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/16/24.
//

import SwiftUI

struct PrivacyView: View {
    let description: String
    var body: some View {
        HStack {
            Image(systemName: "lock.shield")
                .font(.title)
            Text("Your data never leaves your device.\n\(description)")
                .font(.caption2)
                .multilineTextAlignment(.leading)
        }
        .padding(7)
        .foregroundStyle(.secondary)
        .background {
            RoundedRectangle(cornerRadius: 10).fill(Color.secondaryBackgroundColor)
        }
        .padding(.bottom, 30)
    }
}


// MARK: - Extensions
extension Bool {
    init(TorF: String) {
        self.init(TorF == "T")
    }
    
    var TorF: String {
        self ? "T" : "F"
    }
}

extension Date {
    static func monthName(_ month: Int) -> String {
        return switch month {
        case 1: "January"
        case 2: "February"
        case 3: "March"
        case 4: "April"
        case 5: "May"
        case 6: "June"
        case 7: "July"
        case 8: "August"
        case 9: "September"
        case 10: "October"
        case 11: "November"
        case 12: "December"
        default:
            fatalError("Invalid month")
        }
    }
    
    static func from(year: Int, month: Int, day: Int, hour: Int? = nil, minute: Int? = nil, timeZoneOffset: Int = 7) -> Date {
        let components = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
        return Calendar.current.date(from:components)!.addingTimeInterval(TimeInterval(timeZoneOffset * 60 * 60))
    }
    
    var endOfDay: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        return calendar.date(from: components)!
    }
    
    var weekOfYear: Int {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.component(.weekOfYear, from: self)
    }
    
    var month: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: self)
        return components.month!
    }

    var day: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self)
        return components.day!
    }
    
    static func monthsAgoThe1st(count months: Int) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: Date.now)
        let month = components.month! - months
        let year = components.year!
        
        return Date.from(year: year - Int(month.signum() > 0 ? 0 : 1),
                         month: month.signum() > 0 ? month : 12 + month,
                         day: 1)
    }
    
    var startOfWeek: Date {
        let gregorian = Calendar.current
        return gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }
    
    var endOfWeek: Date {
        let gregorian = Calendar.current
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        return gregorian.date(byAdding: .day, value: 7, to: sunday)!.advanced(by: -1)
    }
    
    var startOfMonth: Date {
        let gregorian = Calendar.current
        return gregorian.date(from: gregorian.dateComponents([.year, .month], from: self))!
    }
    
    var endOfMonth: Date {
        let gregorian = Calendar.current
        return gregorian.date(byAdding: .month, value: 1, to: self.startOfMonth)!.addingTimeInterval(-1)
    }

    static func monthsAgoSunday(count months: Int) -> Date {
        let calendar = Calendar.current
        let date = Date.monthsAgoThe1st(count: months)
        let components = calendar.dateComponents([.year, .month], from: date)
        
        // Calculate start and end of the current year (or month with `.month`):
        let interval = calendar.dateInterval(of: .month, for: date)!
        // Compute difference in days:
        let daysInMonth = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        
        return Date.from(year: components.year!,
                         month: components.month!,
                         day: min(Date.now.day, daysInMonth)).startOfWeek
    }
    
    func isSame(_ units: Calendar.Component..., as date: Date) -> Bool {
        let calendar = Calendar.current
        var comparisonComponents: Set<Calendar.Component> = Set(units)
        comparisonComponents.formUnion([.year, .month])

        let components1 = calendar.dateComponents(comparisonComponents, from: self)
        let components2 = calendar.dateComponents(comparisonComponents, from: date)
        
        return comparisonComponents.reduce(true) { isSame, unit in
            isSame && components1.value(for: unit) == components2.value(for: unit)
        }
    }
}

extension String {
    public subscript(_ idx: Int) -> Character {
        self[self.index(self.startIndex, offsetBy: idx)]
    }
}

extension Binding {
    static func convert<TInt, TFloat>(from intBinding: Binding<TInt>) -> Binding<TFloat>
    where TInt:   BinaryInteger,
          TFloat: BinaryFloatingPoint{
              
              Binding<TFloat> (
                get: { TFloat(intBinding.wrappedValue) },
                set: { intBinding.wrappedValue = TInt($0) }
              )
          }
    
    static func convert<TFloat, TInt>(from floatBinding: Binding<TFloat>) -> Binding<TInt>
    where TFloat: BinaryFloatingPoint,
          TInt:   BinaryInteger {
              
              Binding<TInt> (
                get: { TInt(floatBinding.wrappedValue) },
                set: { floatBinding.wrappedValue = TFloat($0) }
              )
          }
}

func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

func Int(_ boolean: Bool) -> Int {
    boolean ? 1 : 0
}

func Double(_ boolean: Bool) -> Double {
    boolean ? 1.0 : 0.0
}

extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition { transform(self) }
        else { self }
    }
}

import Charts
extension ChartContent {
    @ChartContentBuilder
    func `if`<Transform: ChartContent>(_ condition: Bool, transform: (Self) -> Transform) -> some ChartContent {
        if condition { transform(self) }
        else { self }
    }
}

public extension Color {
    #if os(macOS)
    static let backgroundColor = Color(NSColor.windowBackgroundColor)
    static let secondaryBackgroundColor = Color(NSColor.controlBackgroundColor)
    #else
    static let backgroundColor = Color(UIColor.systemBackground)
    static let secondaryBackgroundColor = Color(UIColor.secondarySystemBackground)
    #endif
}
