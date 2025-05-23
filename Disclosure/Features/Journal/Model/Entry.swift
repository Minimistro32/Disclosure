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
    }
}
