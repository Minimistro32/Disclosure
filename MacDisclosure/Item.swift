//
//  Item.swift
//  MacDisclosure
//
//  Created by Tyson Freeze on 3/13/24.
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
