//
//  Relapse.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/3/24.
//

import Foundation
import SwiftData

typealias Relapse = DisclosureSchema.v1_0_0.RelapseModel

extension DisclosureSchema.v1_0_0 {
    @Model
    class RelapseModel {
        var date: Date
        var reminder: Bool
        var intensity: Int
        var compulsivity: Int //how strong the urges were
        var notes: String
        var triggers: Blahst
        private(set) var dummy: Bool
        
        init(date: Date = Date(), reminder: Bool = false, intensity: Int = 0, compulsivity: Int = 0, notes: String = "", triggers: [String] = [], dummy: Bool = false) {
            self.date = date
            self.reminder = reminder
            self.intensity = intensity
            self.compulsivity = compulsivity
            self.notes = notes
            self.triggers = Blahst(triggers)
            self.dummy = dummy
        }
        
        static func categoricalIntensity(for intensity: Double) -> String {
            if intensity > 8 {
                return "New Material"
            } else if intensity > 4 {
                return "Nudity"
            } else if intensity > 2 {
                return "Revealing Clothes"
            }
            return "Masturbation"
        }
        
        //    static func categoricalIntensity(for category: String) -> Int {
        //        if category == "New Material" {
        //            return 8
        //        } else if category == "Nudity" {
        //            return 4
        //        } else if category == "Revealing Clothes" {
        //            return 2
        //        }
        //        return 0
        //    }
        
        var categoricalIntensity: String {
            if intensity > 8 {
                return "New Material"
            } else if intensity > 4 {
                return "Nudity"
            } else if intensity > 2 {
                return "Revealing Clothes"
            }
            return "Masturbation"
        }
    }
}
