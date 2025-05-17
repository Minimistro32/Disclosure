//
//  Migra.swift
//  Disclosure
//
//  Created by Tyson Freeze on 5/17/25.
//

import SwiftData

enum MigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [RelapseSchemaV1_0_0.self]
    }
    
    static var stages: [MigrationStage] {
        []
    }
    
//    static let migrateV2toV3 = MigrationStage.lightweight(
//        fromVersion: SampleTripsSchemaV2.self,
//        toVersion: SampleTripsSchemaV3.self
//    )
}
