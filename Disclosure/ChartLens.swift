//
//  ChartLens.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/27/24.
//

import SwiftUI

enum ChartLens: String, CaseIterable, Identifiable {
    var id: Self { return self }
    case none = "Count"
    case intensity = "Intensity"
    case compulsion = "Urges"
    
    var isGraded: Bool {
        self == .intensity || self == .compulsion
    }
    
    var color: Color {
        switch self {
        case ChartLens.none:
            Color.accent
        case ChartLens.intensity:
            Color.intense
        case ChartLens.compulsion:
            Color.purple
        }
    }
}
