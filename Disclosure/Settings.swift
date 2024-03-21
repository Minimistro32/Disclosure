//
//  Settings.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/21/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Settings {
    var analyzeBadges: Bool
    var callBadge: Bool
    var callReminders: Bool
    var callReminderTime: Date
    var animatedCallSuggestions: Bool
    
    init(analyzeBadges: Bool=true, callBadge: Bool=true, callReminders: Bool=false, callReminderTime: Date=Date.now, animatedCallSuggestions: Bool=true) {
        self.analyzeBadges = analyzeBadges
        self.callBadge = callBadge
        self.callReminders = callReminders
        self.callReminderTime = callReminderTime
        self.animatedCallSuggestions = animatedCallSuggestions
    }
}
