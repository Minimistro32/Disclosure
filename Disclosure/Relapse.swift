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
    var compulsivity: Int
    var notes: String
    var triggers: Blahst
    var disclosed: Bool
    
    init(date: Date = Date(), reminder: Bool = false, intensity: Int = 0, compulsivity: Int = 0, notes: String = "", triggers: [String] = [], disclosed: Bool = false) {
        self.date = date
        self.reminder = reminder
        self.intensity = intensity
        self.compulsivity = compulsivity
        self.notes = notes
        self.triggers = Blahst(triggers)
        self.disclosed = disclosed
    }
}

struct Blahst: Codable, Identifiable {
    var id = UUID()
    static let expansion = ["Bored", "Loneliness", "Anger", "Hunger", "Stress", "Tiredness"]
    
    var bored: Bool
    var loneliness: Bool
    var anger: Bool
    var hunger: Bool
    var stress: Bool
    var tiredness: Bool
    
    var array: [Bool] {
        get {
            return [bored, loneliness, anger, hunger, stress, tiredness]
        }
        set(triggers) {
            self.bored = triggers[0]
            self.loneliness = triggers[1]
            self.anger = triggers[2]
            self.hunger = triggers[3]
            self.stress = triggers[4]
            self.tiredness = triggers[5]
        }
    }
    
    init(_ triggers: [String]) {
        self.bored = triggers.contains(Blahst.expansion[0])
        self.loneliness = triggers.contains(Blahst.expansion[1])
        self.anger = triggers.contains(Blahst.expansion[2])
        self.hunger = triggers.contains(Blahst.expansion[3])
        self.stress = triggers.contains(Blahst.expansion[4])
        self.tiredness = triggers.contains(Blahst.expansion[5])
    }
}

struct TestData {
    static let spreadsheet: [Relapse] = [
        //February
        Relapse(date: Date.from(year: 2024, month: 2, day: 3), intensity: 2, compulsivity: 5),
        Relapse(date: Date.from(year: 2024, month: 2, day: 5), intensity: 6, compulsivity: 5),
        Relapse(date: Date.from(year: 2024, month: 2, day: 5), intensity: 8, compulsivity: 5),
        Relapse(date: Date.from(year: 2024, month: 2, day: 10), intensity: 2, compulsivity: 5),
        Relapse(date: Date.from(year: 2024, month: 2, day: 17), intensity: 4, compulsivity: 5),
        Relapse(date: Date.from(year: 2024, month: 2, day: 20), intensity: 2, compulsivity: 5),
        Relapse(date: Date.from(year: 2024, month: 2, day: 26), intensity: 10, compulsivity: 5),
        Relapse(date: Date.from(year: 2024, month: 2, day: 26), intensity: 8, compulsivity: 5),
        //Etc...
        Relapse(date: Date.from(year: 2024, month: 1, day: 10), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2024, month: 1, day: 18), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2024, month: 1, day: 26), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 1900, month: 1, day: 0), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 12, day: 6), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 12, day: 9), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 12, day: 13), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 11, day: 3), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 11, day: 7), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 11, day: 14), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 11, day: 16), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 11, day: 17), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 11, day: 30), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 10, day: 6), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 10, day: 7), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 10, day: 11), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 10, day: 17), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 10, day: 20), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 10, day: 26), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 9, day: 4), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 9, day: 9), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 9, day: 12), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 9, day: 15), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 9, day: 22), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 9, day: 29), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 8, day: 7), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 8, day: 9), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 8, day: 11), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 8, day: 23), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 8, day: 26), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 7, day: 8), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 7, day: 9), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 7, day: 11), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 7, day: 15), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 7, day: 19), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 6, day: 3), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 6, day: 5), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 6, day: 9), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 6, day: 13), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 6, day: 14), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 6, day: 22), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 6, day: 23), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 6, day: 25), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 6, day: 26), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 6, day: 30), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2024, month: 1, day: 10), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2024, month: 1, day: 18), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2024, month: 1, day: 26), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 5, day: 1), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 5, day: 8), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 5, day: 9), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 5, day: 10), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 5, day: 16), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 5, day: 19), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 5, day: 21), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 5, day: 25), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 5, day: 29), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 5, day: 31), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 4, day: 2), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 4, day: 3), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 4, day: 7), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 4, day: 9), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 4, day: 15), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 4, day: 19), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 4, day: 20), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 4, day: 21), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 4, day: 26), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 4, day: 27), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 4, day: 29), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 3, day: 1), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 3, day: 2), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 3, day: 16), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 3, day: 21), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 3, day: 22), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 3, day: 27), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 2, day: 4), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 2, day: 8), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 2, day: 10), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 2, day: 12), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 2, day: 16), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 2, day: 22), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 2, day: 23), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 2, day: 24), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 1, day: 6), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 1, day: 11), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 1, day: 16), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 1, day: 19), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 1, day: 23), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 1, day: 25), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 1, day: 27), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 1, day: 31), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 12, day: 2), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 12, day: 3), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 12, day: 6), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 12, day: 9), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 12, day: 13), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 12, day: 16), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 12, day: 18), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 12, day: 20), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 12, day: 23), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 12, day: 28), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 11, day: 4), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 11, day: 5), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 11, day: 8), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 11, day: 10), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 11, day: 12), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 11, day: 13), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 11, day: 18), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 11, day: 25), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 10, day: 1), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 10, day: 7), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 10, day: 8), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 10, day: 11), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 10, day: 14), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 10, day: 18), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 10, day: 25), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 10, day: 26), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 9, day: 4), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 9, day: 14), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 9, day: 15), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 9, day: 23), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 9, day: 29), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 9, day: 30), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 8, day: 3), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 8, day: 4), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 8, day: 9), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 8, day: 18), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 8, day: 27), intensity: 5, compulsivity: 5),
        Relapse(date: Date.from(year: 2022, month: 8, day: 30), intensity: 5, compulsivity: 5)
    ]
    
    static let october: [Relapse] = [
        Relapse(date: Date.from(year: 2023, month: 10, day: 6), intensity: 10, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 10, day: 6), intensity: 10, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 10, day: 7), intensity: 1, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 10, day: 11), intensity: 1, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 10, day: 17), intensity: 1, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 10, day: 20), intensity: 10, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 10, day: 26), intensity: 10, compulsivity: 5),
        Relapse(date: Date.from(year: 2023, month: 10, day: 26), intensity: 10, compulsivity: 5)
    ]
}
