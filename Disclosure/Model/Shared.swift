//
//  Shared.swift
//  Disclosure
//
//  Created by Tyson Freeze on 4/2/24.
//

import SwiftData

struct Shared {
    static let RELOAD_MODEL = false
    
    static var modelContainer: ModelContainer = {
        let config: ModelConfiguration = ModelConfiguration(groupContainer: .identifier("group.Tyson-Freeze.Disclosure"))
        do {
            return try ModelContainer(
                for: Schema(versionedSchema: LatestSchema.self),
                migrationPlan: MigrationPlan.self,
                configurations: config
            )
        } catch {
             fatalError("Could not initialize ModelContainer")
        }
    }()
}


