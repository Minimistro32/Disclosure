//
//  Helpers.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/16/24.
//

import SwiftUI

// MARK: - Extensions
extension Date {
    static func from(year: Int, month: Int, day: Int, hour: Int? = nil, minute: Int? = nil, timeZoneOffset: Int = 7) -> Date {
        let components = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
        return Calendar.current.date(from:components)!.addingTimeInterval(TimeInterval(timeZoneOffset * 60 * 60))
    }
    
    func isSame(as date: Date, unit: Calendar.Component) -> Bool {
        let calendar = Calendar.current
        let comparisonComponents: Set<Calendar.Component> = [.year, .month, unit]
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

//extension TimeInterval {
//    func clampToDay() -> TimeInterval {
//        return self - self.truncatingRemainder(dividingBy: 24 * 60 * 60)
//    }
//}
