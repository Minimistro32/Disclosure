//
//  AppIntent.swift
//  DisclosureWidgets
//
//  Created by Tyson Freeze on 3/21/24.
//

import WidgetKit
import AppIntents
import SwiftUI

enum WidgetColor: String, AppEnum, CaseDisplayRepresentable {
    case white = "White"
    case indigo = "Indigo"
    
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Accent Color")
    static var caseDisplayRepresentations: [WidgetColor : DisplayRepresentation] = [
        .white: DisplayRepresentation("White"),
        .indigo: DisplayRepresentation("Indigo")
    ]
    
    var get: AnyShapeStyle {
        switch self {
        case .white:
            .init(Color.backgroundColor)
        case .indigo:
            .init(Color.indigo.gradient)
        }
    }
}

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Customize Widget"
    static var description = IntentDescription("Selects settings to alter the display.")
    
    // An example configurable parameter.
    @Parameter(title: "Discreet", default: true)
    var discreet: Bool
    
    @Parameter(title: "Preferred Metric", default: MetricType.current)
    var metric: MetricType
    
    @Parameter(title: "Accent Color", default: WidgetColor.white)
    var color: WidgetColor
}


