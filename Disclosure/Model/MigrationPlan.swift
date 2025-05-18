//
//  Migra.swift
//  Disclosure
//
//  Created by Tyson Freeze on 5/17/25.
//

import SwiftData

enum MigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [DisclosureSchema.v1_0_0.self]
    }
    
    static var stages: [MigrationStage] {
        []
    }
}

typealias LatestSchema = DisclosureSchema.v1_0_0
enum DisclosureSchema {
    enum v1_0_0: VersionedSchema {
        static var versionIdentifier = Schema.Version(1, 0, 0)
        static var models: [any PersistentModel.Type] = [
            v1_0_0.RelapseModel.self,
            v1_0_0.Person.self,
            v1_0_0.Entry.self,
            v1_0_0.Settings.self
        ]
    }
}
