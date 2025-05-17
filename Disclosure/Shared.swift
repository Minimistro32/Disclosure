//
//  Shared.swift
//  Disclosure
//
//  Created by Tyson Freeze on 4/2/24.
//

import SwiftData

//TODO: figure out database migrations for app store

struct Shared {
    static let RELOAD_MODEL = true
    
    static var modelContainer: ModelContainer = {
        let schema = Schema([Relapse.self, Person.self, Entry.self, Settings.self])
        let config: ModelConfiguration = ModelConfiguration(groupContainer: .identifier("group.Tyson-Freeze.Disclosure"))
        do {
            return try ModelContainer(for: schema, migrationPlan: MigrationPlan.self, configurations: config)
        } catch {
             fatalError("Could not initialize ModelContainer")
        }
    }()
}


