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
    private var useBottomLabel: Bool? {
        average > 9 || current > 99 ? true : nil
    }
    
    var body: some View {
        Spacer()
        MetricView(number: average, type: .average, discreet: discreet, useBottomLabel: useBottomLabel)
        Spacer()
        MetricView(number: current, type: .current, discreet: discreet, useBottomLabel: useBottomLabel)
        Spacer()
    }
}

struct MetricView: View {
    let number: Int
    let type: MetricType
    var discreet: Bool = false
    private var labelText: String {
        discreet ? (type == .average ? "Average" : "Days") : type.rawValue
    }
    var useBottomLabel: Bool? = nil
    private var _useBottomLabel: Bool {
        if let useBottomLabel {
            return useBottomLabel
        } else {
            return number > 99 || (type == .average && number > 9)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(String(number))
                    .font(.system(size: 70))
                if !_useBottomLabel {
                    Text(labelText)
                }
            }
            if _useBottomLabel {
                Text(labelText)
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
