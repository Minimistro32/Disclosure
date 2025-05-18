//
//  Settings.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/21/24.
//

import Foundation
import SwiftUI
import SwiftData

typealias Settings = DisclosureSchema.v1_0_0.Settings

extension DisclosureSchema.v1_0_0 {
    @Model
    class Settings {
        //tab1
        var callBadge: Bool
        var callReminders: Bool
        var callReminderTime: Date
        var animatedCallSuggestions: Bool
        
        //tab2
        var analyzeBadges: Bool
        
        init(callBadge: Bool=true, callReminders: Bool=true, callReminderTime: Date=Date.from(year: 2023, month: 3, day: 21, hour: 9), animatedCallSuggestions: Bool=true, analyzeBadges: Bool=true) {
            //tab1
            self.callBadge = callBadge
            self.callReminders = callReminders
            self.callReminderTime = callReminderTime
            self.animatedCallSuggestions = animatedCallSuggestions
            
            //tab2
            self.analyzeBadges = analyzeBadges
        }
    }
}
