//
//  Entry.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/14/24.
//

import Foundation
import SwiftData

@Model
class Entry {
    static var instanceCount: Int = 0
    let title: String
    let body: String
    let isGoal: Bool
    let date: Date
    
    init(title: String, body: String, isGoal: Bool = false, date: Date = Date.now) {
        self.title = title + String(Self.instanceCount)
        self.body = body
        self.isGoal = isGoal
        self.date = date
        Self.instanceCount += 1
    }
}
