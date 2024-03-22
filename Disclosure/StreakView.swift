//
//  StreakView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/21/24.
//

import SwiftUI
import AppIntents

struct StreakView: View {
    let average: Int
    let current: Int
    var discreet: Bool = false
    
    var body: some View {
        Spacer()
        MetricView(number: average, type: .average, discreet: discreet)
        Spacer()
        MetricView(number: current, type: .current, discreet: discreet)
        Spacer()
    }
}

struct MetricView: View {
    let number: Int
    let type: MetricType
    var discreet: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text(String(number))
                    .font(.system(size: 70))
                Text(discreet && type == .average ? "Average" : "Days")
            }
            if !discreet {
                Text(type.rawValue)
                    .multilineTextAlignment(.center)
            }
        }
    }
}


enum MetricType: String, AppEnum, CaseDisplayRepresentable {
    case current = "Days Sober"
    case average = "Average Days"
    
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Preferred Metric")
    static var caseDisplayRepresentations: [MetricType : DisplayRepresentation] = [
        .current: DisplayRepresentation("Current Streak"),
        .average: DisplayRepresentation("Average Streak")
    ]
}
