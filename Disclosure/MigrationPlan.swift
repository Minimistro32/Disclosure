//
//  Migra.swift
//  Disclosure
//
//  Created by Tyson Freeze on 5/17/25.
//

import SwiftData

enum MigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [
            DisclosureSchema.v1_0_0.self
            , DisclosureSchema.v1_0_1.self
        ]
    }
    
    static var stages: [MigrationStage] {
//        []
        [migrateV1toV2]
    }
    
    static let migrateV1toV2 = MigrationStage.lightweight(
        fromVersion: DisclosureSchema.v1_0_0.self,
        toVersion: DisclosureSchema.v1_0_1.self
    )
//    
//    static let migrateV1toV2 = MigrationStage.custom(
//        fromVersion: DisclosureSchema.v1_0_0.self,
//        toVersion: DisclosureSchema.v1_0_1.self,
//        willMigrate: nil, didMigrate: { context in
//            print("did migrate")
//            let relapses = try context.fetch(FetchDescriptor<DisclosureSchema.v1_0_1.RelapseModel>())
//            print(relapses.count)
//            for relapse in relapses {
//                relapse.test = "LOLZ"
//            }
//            
//            try context.save()
//        }
//    )
}

typealias LatestSchema = DisclosureSchema.v1_0_1
enum DisclosureSchema {
    enum v1_0_1: VersionedSchema {
        static var versionIdentifier = Schema.Version(1, 0, 1)
        static var models: [any PersistentModel.Type] = [
            v1_0_1.RelapseModel.self,
            v1_0_0.Person.self,
            v1_0_0.Entry.self,
            v1_0_0.Settings.self
        ]
    }
    
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
