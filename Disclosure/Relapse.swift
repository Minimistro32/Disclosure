//
//  Relapse.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/3/24.
//

import Foundation
import SwiftData
import Charts

@Model //gets me identifiable for free
class Relapse {
    let date: Date
    let analyzed: Bool
    
    let intensity: Int?
    let compulsivity: Int?
    let notes: String?
    
    init(date: Date, analyzed: Bool = false, intensity: Int?, compulsivity: Int?, notes: String? = nil) {
        self.date = date
        self.analyzed = analyzed
        self.intensity = intensity
        self.compulsivity = compulsivity
        self.notes = notes
    }
}

struct RelapseDay: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
    let intensity: Int
    let compulsivity: Int
}

struct MockData {

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
    
    // could be useful
    //    static let octoberDayView = Dictionary(grouping: october) { relapse in relapse.date }
    
    static let octoberDayView = [
        RelapseDay(date: Date.from(year: 2023, month: 10, day: 6), count: 2, intensity: 10, compulsivity: 5),
        RelapseDay(date: Date.from(year: 2023, month: 10, day: 7), count: 1, intensity: 1, compulsivity: 5),
        RelapseDay(date: Date.from(year: 2023, month: 10, day: 11), count: 1, intensity: 1, compulsivity: 5),
        RelapseDay(date: Date.from(year: 2023, month: 10, day: 17), count: 1, intensity: 1, compulsivity: 5),
        RelapseDay(date: Date.from(year: 2023, month: 10, day: 20), count: 1, intensity: 10, compulsivity: 5),
        RelapseDay(date: Date.from(year: 2023, month: 10, day: 26), count: 2, intensity: 10, compulsivity: 5)
    ]
    
    static let novemberDayView = [
        RelapseDay(date: Date.from(year: 2023, month: 1, day: 1), count: 1, intensity: 1, compulsivity: 5),
        RelapseDay(date: Date.from(year: 2023, month: 1, day: 2), count: 5, intensity: 2, compulsivity: 5),
        RelapseDay(date: Date.from(year: 2023, month: 1, day: 3), count: 2, intensity: 3, compulsivity: 5),
        RelapseDay(date: Date.from(year: 2023, month: 1, day: 4), count: 1, intensity: 4, compulsivity: 5),
        RelapseDay(date: Date.from(year: 2023, month: 1, day: 5), count: 1, intensity: 5, compulsivity: 5),
        RelapseDay(date: Date.from(year: 2023, month: 1, day: 6), count: 1, intensity: 6, compulsivity: 5),
        RelapseDay(date: Date.from(year: 2023, month: 1, day: 7), count: 1, intensity: 7, compulsivity: 5),
        RelapseDay(date: Date.from(year: 2023, month: 1, day: 8), count: 1, intensity: 8, compulsivity: 5),
        RelapseDay(date: Date.from(year: 2023, month: 1, day: 9), count: 1, intensity: 9, compulsivity: 5),
        RelapseDay(date: Date.from(year: 2023, month: 1, day: 10), count: 2, intensity: 10, compulsivity: 5),
    ]        
    
    static let liveJanDayView = [
        RelapseDay(date: Date.from(year: 2024, month: 1, day: 10), count: 1, intensity: 8, compulsivity: 5),
        RelapseDay(date: Date.from(year: 2024, month: 1, day: 18), count: 1, intensity: 2, compulsivity: 5),
        RelapseDay(date: Date.from(year: 2024, month: 1, day: 26), count: 1, intensity: 7, compulsivity: 5)
    ]
    
    static let hourView = [
        RelapseDay(date: Date.from(year: 2023, month: 1, day: 1, hour: 8), count: 5, intensity: 2, compulsivity: 5),
        RelapseDay(date: Date.from(year: 2023, month: 1, day: 1, hour: 9), count: 2, intensity: 3, compulsivity: 5),
        RelapseDay(date: Date.from(year: 2023, month: 1, day: 1, hour: 10), count: 1, intensity: 4, compulsivity: 5),
        RelapseDay(date: Date.from(year: 2023, month: 1, day: 1, hour: 12), count: 1, intensity: 5, compulsivity: 5),
        RelapseDay(date: Date.from(year: 2023, month: 1, day: 1, hour: 13), count: 1, intensity: 6, compulsivity: 5),
        RelapseDay(date: Date.from(year: 2023, month: 1, day: 1, hour: 15), count: 1, intensity: 7, compulsivity: 5),
        RelapseDay(date: Date.from(year: 2023, month: 1, day: 1, hour: 16), count: 1, intensity: 8, compulsivity: 5),
        RelapseDay(date: Date.from(year: 2023, month: 1, day: 1, hour: 18), count: 1, intensity: 9, compulsivity: 5),
        RelapseDay(date: Date.from(year: 2023, month: 1, day: 1, hour: 19), count: 2, intensity: 10, compulsivity: 5),
    ]
    
}
