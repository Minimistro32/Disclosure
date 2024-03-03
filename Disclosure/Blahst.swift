//
//  Blahst.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/3/24.
//

import Foundation

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
