//
//  Person.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/2/24.
//

import Foundation
import SwiftData

typealias Person = DisclosureSchema.v1_0_0.Person

extension DisclosureSchema.v1_0_0 {
    @Model
    class Person {
        var name: String
        var relation: Relation {
            didSet {
                sortValue = relation.sortValue
            }
        }
        var sortValue: Int //for sorting an Enum using SwiftData
        private var rawPhone: String
        var phone: String {
            get {
                self.rawPhone
            }
            set {
                self.rawPhone = newValue.components(separatedBy: CharacterSet.decimalDigits.inverted)
                    .joined()
            }
        }
        
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
        var codeWord: String {
            rawCodeWord.isEmpty ? "I relapsed" : rawCodeWord
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
            self.rawPhone = phone.components(separatedBy: CharacterSet.decimalDigits.inverted)
                .joined()
            self.sortValue = relation.sortValue
            self.latestCall = latestCall
            self.canText = canText ?? false
            self.rawCodeWord = codeWord
            self.textOverride = textMsgOverride
        }
    }
}
