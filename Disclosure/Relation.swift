//
//  Relation.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/2/24.
//

import Foundation

enum Relation: String, Codable, CaseIterable, Identifiable {
    var id: Self { return self}
    case sponsor = "Sponsor"
    case group = "Group"
    case other = "Other"
    
    var sortValue: Int {
        switch self {
        case .sponsor:
            0
        case .group:
            1
        case .other:
            2
        }
    }
}
