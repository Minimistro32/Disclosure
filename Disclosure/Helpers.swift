//
//  Helpers.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/16/24.
//

import Foundation

// MARK: - Extensions
extension Date {
    static func from(year: Int, month: Int, day: Int, hour: Int? = nil, minute: Int? = nil) -> Date {
        let components = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
        return Calendar.current.date(from:components)!
    }
}

extension String {
    public subscript(_ idx: Int) -> Character {
        self[self.index(self.startIndex, offsetBy: idx)]
    }
}
