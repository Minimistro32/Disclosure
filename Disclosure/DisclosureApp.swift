//
//  DisclosureApp.swift
//  Disclosure
//
//  Created by Tyson Freeze on 1/29/24.
//

import SwiftUI
import SwiftData

@main
struct DisclosureApp: App {

    var body: some Scene {
  
//        TODO: THIS IS THE COMPLEX WAY
//        let container: ModelContainer = {
//            let schema = Schema([Relapse.self])
//            let config: [ModelConfiguration] = [] //ModelConfiguration(groupContainer: _) used for integrating with widgets or other deployments
//            let container = try! ModelContainer(for: schema, configurations: config)
//            return container
//        }()
        
        WindowGroup {
            ContentView()
        }
//        TODO: THIS IS THE COMPLEX WAY
//        .modelContainer(container)
        
        .modelContainer(for: [Relapse.self])
    }
}
