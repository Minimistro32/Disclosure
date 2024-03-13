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
    var sortValue: Int //for sorting an Enum using SwiftData
    var phone: String
    var latestCall: Date?
    var daysSinceCall: Int? {
        if let latestCall {
            return Int(latestCall.timeIntervalSinceNow / -89600)
        } else {
            return nil
        }
    }
    
    //texting
    var canText: Bool
    var rawCodeWord: String
    static var defaultCodeWord: String = "I relapsed"
    var codeWord: String {
        rawCodeWord.isEmpty ? Self.defaultCodeWord : rawCodeWord
    }
    var textOverride: String = ""
    
    func draftText(relapse: Relapse? = nil) -> String {
        if !textOverride.isEmpty { return textOverride }
        
        var text = "Hey"
        let firstName = String(self.name.split(separator: " ").first ?? "")
        if !firstName.isEmpty {
            text += " " + firstName
        }
        text += ", "

        if let relapse {
            text += self.codeWord + ". "
            if relapse.triggers.count > 0 {
                text += "I was " + relapse.triggers.toString() + ". "
            }
            text += "I want to learn from this for next time. Can I talk it through with you?"
        } else {
            text += "I'm feeling triggered. I want to meet and manage some things. I think my unmet needs and triggers are..."
        }
        
        return text
    }
    
    init(name: String = "", relation: Relation = .sponsor, phone: String = "", latestCall: Date? = nil, canText: Bool? = nil, codeWord: String = "", textMsgOverride: String = "") {
        self.name = name
        self.relation = relation
        self.phone = phone
        self.sortValue = relation.sortValue
        self.latestCall = latestCall
        self.canText = canText ?? false
        self.rawCodeWord = codeWord
        self.textOverride = textMsgOverride
    }
}
