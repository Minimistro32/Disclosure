//
//  SampleData.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/2/24.
//

import Foundation

struct SampleData {
    static let entries: [Entry] = [
        Entry(isGoal: true, title: "Start Strong", body: "Set clear intentions.", date: Date.from(year: 2024, month: 12, day: 1)),
        Entry(isGoal: false, title: "Rough Morning", body: "Cravings were intense.", date: Date.from(year: 2024, month: 12, day: 2)),
        Entry(isGoal: false, title: "Walked It Off", body: "Exercise really helped.", date: Date.from(year: 2024, month: 12, day: 3)),
        Entry(isGoal: true, title: "Weekly Goal", body: "Avoid triggers this week.", date: Date.from(year: 2024, month: 12, day: 4)),
        Entry(isGoal: false, title: "Reflected", body: "Journaling felt grounding.", date: Date.from(year: 2024, month: 12, day: 5)),
        Entry(isGoal: false, title: "Made It Through", body: "Felt tempted, but stayed clean.", date: Date.from(year: 2024, month: 12, day: 7)),
        Entry(isGoal: true, title: "New Commitment", body: "Stay\naccountable\ndaily.", date: Date.from(year: 2024, month: 12, day: 8)),
        Entry(isGoal: false, title: "Support Group", body: "Good to share and listen.", date: Date.from(year: 2024, month: 12, day: 9)),
        Entry(isGoal: false, title: "Slipped", body: "Owned it. Restarted right away.", date: Date.from(year: 2024, month: 12, day: 10)),
        Entry(isGoal: false, title: "Feeling Hopeful", body: "Energy is returning.", date: Date.from(year: 2024, month: 12, day: 11)),

    ]
    
    static let team: [Person] = [
        Person(name: "Jackson Miller", relation: Relation.sponsor, phone: "999999999", latestCall: Date.from(year: 2024, month: 12, day: 10), canText: true),
        Person(name: "Ethan", relation: Relation.group, phone: "999999999", latestCall: Date.from(year: 2024, month: 12, day: 8), canText: true),
        Person(name: "Landon", relation: Relation.group, phone: "999999999", latestCall: Date.from(year: 2024, month: 12, day: 6)),
        Person(name: "Caleb", relation: Relation.group, phone: "999999999", latestCall: Date.from(year: 2024, month: 12, day: 6), canText: true),
        Person(name: "Mason", relation: Relation.group, phone: "999999999"),
        Person(name: "Garrett", relation: Relation.group, phone: "999999999", canText: true),
        Person(name: "Mom", relation: Relation.other, phone: "999999999", latestCall: Date.from(year: 2024, month: 11, day: 20), canText: true),
        Person(name: "Sister", relation: Relation.other, phone: "999999999"),
        Person(name: "Wife", relation: Relation.other, phone: "999999999", latestCall: Date.from(year: 2024, month: 12, day: 10), canText: true)
    ]
    
    static let relapses: [Relapse] = [
        Relapse(date: Date.from(year: 2024, month: 9, day: 3), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10), notes: "I was really struggling with this one.\nHow can I make it easier?", triggers: ["Bored", "Loneliness", "Anger"]),
        Relapse(date: Date.from(year: 2024, month: 9, day: 7), reminder: true, intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10), notes: "How can I avoid these triggers in the future?", triggers: ["Hunger", "Stress", "Tiredness"]),
        Relapse(date: Date.from(year: 2024, month: 9, day: 14), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10), notes: "This is going to be difficult, but I'm feeling more optimistic.", triggers: ["Loneliness", "Tiredness"]),
        Relapse(date: Date.from(year: 2024, month: 9, day: 16), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 9, day: 17), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 9, day: 30), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 8, day: 6), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 8, day: 7), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 8, day: 11), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 8, day: 17), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 8, day: 20), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 8, day: 26), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 7, day: 4), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 7, day: 9), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 7, day: 12), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 7, day: 15), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 7, day: 22), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 7, day: 29), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 6, day: 7), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 6, day: 9), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 6, day: 11), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 6, day: 23), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 6, day: 26), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 5, day: 8), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 5, day: 9), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 5, day: 11), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 5, day: 15), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 5, day: 19), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 4, day: 3), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 4, day: 5), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 4, day: 9), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 4, day: 13), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 4, day: 14), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 4, day: 22), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 4, day: 23), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 4, day: 25), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 4, day: 26), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 4, day: 30), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 3, day: 1), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 3, day: 8), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 3, day: 9), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 3, day: 10), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 3, day: 16), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 3, day: 19), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 3, day: 21), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 3, day: 25), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 3, day: 29), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        Relapse(date: Date.from(year: 2024, month: 3, day: 31), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
    ]
}
