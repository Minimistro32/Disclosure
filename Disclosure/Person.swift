//
//  Person.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/2/24.
//

import Foundation
import SwiftData

@Model
class Person {
    var name: String
    var relation: Relation {
        didSet {
            sortValue = relation.sortValue
        }
    }
    var phone: String
    var checkInDate: Date?
    var sortValue: Int
    
    var daysSinceCheckIn: Int? {
        if let checkInDate {
            return Int(checkInDate.timeIntervalSinceNow / -89600)
        } else {
            return nil
        }
    }
    
    
    init(name: String = "", relation: Relation = .sponsor, phone: String = "", checkInDate: Date? = nil) {
        self.name = name
        self.relation = relation
        self.phone = phone
        self.checkInDate = checkInDate
        self.sortValue = relation.sortValue
    }
}
