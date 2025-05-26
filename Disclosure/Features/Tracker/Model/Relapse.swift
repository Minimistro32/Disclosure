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
        
        init(date: Date = Date(), reminder: Bool = false, intensity: Int = 0, compulsivity: Int = 0, notes: String = "", triggers: Blahst, dummy: Bool = false) {
            self.date = date
            self.reminder = reminder
            self.intensity = intensity
            self.compulsivity = compulsivity
            self.notes = notes
            self.triggers = triggers
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
        
        
        private static let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            return df
        }()
        
        static func csvHeader() -> String {
            "Date,ShouldAnalyze,Intensity,Compulsivity,Notes,\(Blahst.expansion.joined(separator: ","))\n"
        }
        
        func csvLine() -> String {
            "\(Relapse.dateFormatter.string(from: date)),\(reminder.TorF),\(intensity),\(compulsivity),\(CSV.escape(notes)),\(triggers.array.map(\.TorF).joined(separator: ","))\n"
        }
        
        convenience init?(csvLine: String) {
            var values = CSV.parse(csvLine).map { $0.trimmingCharacters(in: .whitespaces) }
            guard values.count == 11 else { return nil }

            var triggers: [Bool] = []
            for _ in 0..<6 {
                triggers.insert(Bool(TorF: values.removeLast()), at: 0)
            }
            
            guard let date = Relapse.dateFormatter.date(from: values[0]) else { return nil }
            
            self.init(
                date: date,
                reminder: Bool(TorF: values[1]),
                intensity: Int(values[2]) ?? 5,
                compulsivity: Int(values[3]) ?? 5,
                notes: values[4],
                triggers: Blahst(triggers)
            )
        }
    }
}
