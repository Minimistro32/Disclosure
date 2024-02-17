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
//
//struct RelapseDay: Identifiable {
//    let id = UUID()
//    let date: Date
//    let count: Int
//    let intensity: Int
//    let compulsivity: Int
//}
//
//struct MockData {
//
//    static let october: [Relapse] = [
//        Relapse(date: Date.from(year: 2023, month: 10, day: 6), intensity: 10, compulsivity: 5),
//        Relapse(date: Date.from(year: 2023, month: 10, day: 6), intensity: 10, compulsivity: 5),
//        Relapse(date: Date.from(year: 2023, month: 10, day: 7), intensity: 1, compulsivity: 5),
//        Relapse(date: Date.from(year: 2023, month: 10, day: 11), intensity: 1, compulsivity: 5),
//        Relapse(date: Date.from(year: 2023, month: 10, day: 17), intensity: 1, compulsivity: 5),
//        Relapse(date: Date.from(year: 2023, month: 10, day: 20), intensity: 10, compulsivity: 5),
//        Relapse(date: Date.from(year: 2023, month: 10, day: 26), intensity: 10, compulsivity: 5),
//        Relapse(date: Date.from(year: 2023, month: 10, day: 26), intensity: 10, compulsivity: 5)
//    ]
//    
//    // could be useful
//    //    static let octoberDayView = Dictionary(grouping: october) { relapse in relapse.date }
//    
//    static let octoberDayView = [
//        RelapseDay(date: Date.from(year: 2023, month: 10, day: 6), count: 2, intensity: 10, compulsivity: 5),
//        RelapseDay(date: Date.from(year: 2023, month: 10, day: 7), count: 1, intensity: 1, compulsivity: 5),
//        RelapseDay(date: Date.from(year: 2023, month: 10, day: 11), count: 1, intensity: 1, compulsivity: 5),
//        RelapseDay(date: Date.from(year: 2023, month: 10, day: 17), count: 1, intensity: 1, compulsivity: 5),
//        RelapseDay(date: Date.from(year: 2023, month: 10, day: 20), count: 1, intensity: 10, compulsivity: 5),
//        RelapseDay(date: Date.from(year: 2023, month: 10, day: 26), count: 2, intensity: 10, compulsivity: 5)
//    ]
//    
//    static let novemberDayView = [
//        RelapseDay(date: Date.from(year: 2023, month: 1, day: 1), count: 1, intensity: 1, compulsivity: 5),
//        RelapseDay(date: Date.from(year: 2023, month: 1, day: 2), count: 5, intensity: 2, compulsivity: 5),
//        RelapseDay(date: Date.from(year: 2023, month: 1, day: 3), count: 2, intensity: 3, compulsivity: 5),
//        RelapseDay(date: Date.from(year: 2023, month: 1, day: 4), count: 1, intensity: 4, compulsivity: 5),
//        RelapseDay(date: Date.from(year: 2023, month: 1, day: 5), count: 1, intensity: 5, compulsivity: 5),
//        RelapseDay(date: Date.from(year: 2023, month: 1, day: 6), count: 1, intensity: 6, compulsivity: 5),
//        RelapseDay(date: Date.from(year: 2023, month: 1, day: 7), count: 1, intensity: 7, compulsivity: 5),
//        RelapseDay(date: Date.from(year: 2023, month: 1, day: 8), count: 1, intensity: 8, compulsivity: 5),
//        RelapseDay(date: Date.from(year: 2023, month: 1, day: 9), count: 1, intensity: 9, compulsivity: 5),
//        RelapseDay(date: Date.from(year: 2023, month: 1, day: 10), count: 2, intensity: 10, compulsivity: 5),
//    ]        
//    
//    static let liveJanDayView = [
//        RelapseDay(date: Date.from(year: 2024, month: 1, day: 10), count: 1, intensity: 8, compulsivity: 5),
//        RelapseDay(date: Date.from(year: 2024, month: 1, day: 18), count: 1, intensity: 2, compulsivity: 5),
//        RelapseDay(date: Date.from(year: 2024, month: 1, day: 26), count: 1, intensity: 7, compulsivity: 5)
//    ]
//    
//    static let hourView = [
//        RelapseDay(date: Date.from(year: 2023, month: 1, day: 1, hour: 8), count: 5, intensity: 2, compulsivity: 5),
//        RelapseDay(date: Date.from(year: 2023, month: 1, day: 1, hour: 9), count: 2, intensity: 3, compulsivity: 5),
//        RelapseDay(date: Date.from(year: 2023, month: 1, day: 1, hour: 10), count: 1, intensity: 4, compulsivity: 5),
//        RelapseDay(date: Date.from(year: 2023, month: 1, day: 1, hour: 12), count: 1, intensity: 5, compulsivity: 5),
//        RelapseDay(date: Date.from(year: 2023, month: 1, day: 1, hour: 13), count: 1, intensity: 6, compulsivity: 5),
//        RelapseDay(date: Date.from(year: 2023, month: 1, day: 1, hour: 15), count: 1, intensity: 7, compulsivity: 5),
//        RelapseDay(date: Date.from(year: 2023, month: 1, day: 1, hour: 16), count: 1, intensity: 8, compulsivity: 5),
//        RelapseDay(date: Date.from(year: 2023, month: 1, day: 1, hour: 18), count: 1, intensity: 9, compulsivity: 5),
//        RelapseDay(date: Date.from(year: 2023, month: 1, day: 1, hour: 19), count: 2, intensity: 10, compulsivity: 5),
//    ]
//    
//}
