//
//  DisclosureApp.swift
//  Disclosure
//
//  Created by Tyson Freeze on 1/29/24.
//

import SwiftUI
import SwiftData

//TODO: figure out database migrations for app store

@main
struct DisclosureApp: App {
    static let RELOAD_MODEL = true
    
    let container: ModelContainer
    init() {
        let schema = Schema([Relapse.self, Person.self, Entry.self, Settings.self])
        let config: [ModelConfiguration] = [] //ModelConfiguration(groupContainer: _) used for integrating with widgets or other deployments
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
             fatalError("Could not initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup() {
            ContentView()
        }
        .modelContainer(container)
//        .modelContainer(for: [Relapse.self])      //This is the "easy" way
    }
}
