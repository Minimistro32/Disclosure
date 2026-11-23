//
//  SampleData.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/2/24.
//

import Foundation

struct SampleData {
    private static func date(daysAgo: Int, from today: Date, calendar: Calendar) -> Date {
        calendar.date(byAdding: .day, value: -daysAgo, to: today)!
    }

    static var entries: [Entry] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        return [
            Entry(isGoal: true, title: "Start Strong", body: "Set clear intentions.", date: date(daysAgo: 10, from: today, calendar: calendar)),
            Entry(isGoal: false, title: "Rough Morning", body: "Cravings were intense.", date: date(daysAgo: 9, from: today, calendar: calendar)),
            Entry(isGoal: false, title: "Walked It Off", body: "Exercise really helped.", date: date(daysAgo: 8, from: today, calendar: calendar)),
            Entry(isGoal: true, title: "Weekly Goal", body: "Avoid triggers this week.", date: date(daysAgo: 7, from: today, calendar: calendar)),
            Entry(isGoal: false, title: "Reflected", body: "Journaling felt grounding.", date: date(daysAgo: 6, from: today, calendar: calendar)),
            Entry(isGoal: false, title: "Made It Through", body: "Felt tempted, but stayed clean.", date: date(daysAgo: 4, from: today, calendar: calendar)),
            Entry(isGoal: true, title: "New Commitment", body: "Stay\naccountable\ndaily.", date: date(daysAgo: 3, from: today, calendar: calendar)),
            Entry(isGoal: false, title: "Support Group", body: "Good to share and listen.", date: date(daysAgo: 2, from: today, calendar: calendar)),
            Entry(isGoal: false, title: "Slipped", body: "Owned it. Restarted right away.", date: date(daysAgo: 1, from: today, calendar: calendar)),
            Entry(isGoal: false, title: "Feeling Hopeful", body: "Energy is returning.", date: date(daysAgo: 0, from: today, calendar: calendar)),
        ]
    }
    
    static var team: [Person] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        return [
            Person(name: "Jackson Miller", relation: Relation.sponsor, phone: "999999999", latestCall: date(daysAgo: 1, from: today, calendar: calendar), canText: true),
            Person(name: "Ethan", relation: Relation.group, phone: "999999999", latestCall: date(daysAgo: 3, from: today, calendar: calendar), canText: true),
            Person(name: "Landon", relation: Relation.group, phone: "999999999", latestCall: date(daysAgo: 5, from: today, calendar: calendar)),
            Person(name: "Caleb", relation: Relation.group, phone: "999999999", latestCall: date(daysAgo: 5, from: today, calendar: calendar), canText: true),
            Person(name: "Mason", relation: Relation.group, phone: "999999999"),
            Person(name: "Garrett", relation: Relation.group, phone: "999999999", canText: true),
            Person(name: "Mom", relation: Relation.other, phone: "999999999", latestCall: date(daysAgo: 21, from: today, calendar: calendar), canText: true),
            Person(name: "Sister", relation: Relation.other, phone: "999999999"),
            Person(name: "Wife", relation: Relation.other, phone: "999999999", latestCall: date(daysAgo: 1, from: today, calendar: calendar), canText: true)
        ]
    }
    
    static var relapses: [Relapse] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        return [
            Relapse(date: date(daysAgo: 27, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10), notes: "I was really struggling with this one.\nHow can I make it easier?", triggers: ["Bored", "Loneliness", "Anger"]),
            Relapse(date: date(daysAgo: 23, from: today, calendar: calendar), reminder: true, intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10), notes: "How can I avoid these triggers in the future?", triggers: ["Hunger", "Stress", "Tiredness"]),
            Relapse(date: date(daysAgo: 16, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10), notes: "This is going to be difficult, but I'm feeling more optimistic.", triggers: ["Loneliness", "Tiredness"]),
            Relapse(date: date(daysAgo: 14, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 13, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 0, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 55, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 54, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 50, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 44, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 41, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 35, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 88, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 83, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 80, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 77, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 70, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 63, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 115, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 113, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 111, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 99, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 96, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 145, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 144, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 142, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 138, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 134, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 180, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 178, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 174, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 170, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 169, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 161, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 160, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 158, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 157, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 153, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 213, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 206, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 205, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 204, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 198, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 195, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 193, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 189, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 185, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
            Relapse(date: date(daysAgo: 183, from: today, calendar: calendar), intensity: Int.random(in: 1...10), compulsivity: Int.random(in: 1...10)),
        ]
    }
}
