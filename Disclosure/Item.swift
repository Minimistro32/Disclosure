//
//  Item.swift
//  Disclosure
//
//  Created by Tyson Freeze on 1/29/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
