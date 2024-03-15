//
//  Segue.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/11/24.
//

import SwiftUI

struct Segue: Hashable {
    enum destinationView: String {
        case addPersonView = "addPersonView"
        case logView = "logView"
        case loggerView = "loggerView"
        case disclosureView = "disclosureView"
    }
    
    let destination: destinationView
    let payload: AnyHashable?
    
    init(to destination: destinationView, payload: AnyHashable? = nil) {
        self.destination = destination
        self.payload = payload
    }
}
