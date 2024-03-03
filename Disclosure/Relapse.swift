//
//  Relapse.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/3/24.
//

import Foundation
import SwiftData

@Model
class Relapse {
    var date: Date
    var reminder: Bool
    var intensity: Int
    var compulsivity: Int //how strong the urges were
    var notes: String
    var triggers: Blahst
    var dummy: Bool
    
    init(date: Date = Date(), reminder: Bool = false, intensity: Int = 0, compulsivity: Int = 0, notes: String = "", triggers: [String] = [], dummy: Bool = false) {
        self.date = date
        self.reminder = reminder
        self.intensity = intensity
        self.compulsivity = compulsivity
        self.notes = notes
        self.triggers = Blahst(triggers)
        self.dummy = dummy
    }
}
