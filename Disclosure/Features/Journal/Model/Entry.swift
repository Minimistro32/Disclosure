//
//  Entry.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/14/24.
//

import Foundation
import SwiftData

typealias Entry = DisclosureSchema.v1_0_0.Entry

extension DisclosureSchema.v1_0_0 {
    @Model
    class Entry {
        private(set) var isGoal: Bool //could be an enum, but they don't play nice with SwiftData
        private(set) var type: String
        var title: String
        var body: String
        var date: Date
        
        init(isGoal: Bool, title: String = "", body: String = "", date: Date = Date.now) {
            let type = isGoal ? "Goal" : "Note"
            self.isGoal = isGoal
            self.type = type
            self.title = title
            self.body = body
            self.date = date
        }
        
        private static let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            return df
        }()
        
        static func csvHeader() -> String {
            "IsGoal,Title,Body,Date\n"
        }
        
        func csvLine() -> String {
            "\(isGoal ? "T" : "F"),\(CSV.escape(title)),\(CSV.escape(body)),\(Entry.dateFormatter.string(from: date))\n"
        }
        
        convenience init?(csvLine: String) {
            let values = CSV.parse(csvLine).map { $0.trimmingCharacters(in: .whitespaces) }
            guard values.count == 4 else { return nil }
            guard let date = Entry.dateFormatter.date(from: values[3]) else { return nil }
            
            self.init(
                isGoal: Bool(TorF: values[0]),
                title: values[1],
                body: values[2],
                date: date
            )
        }
    }
}
