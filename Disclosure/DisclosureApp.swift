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
        WindowGroup() {
            ContentView()
        }
        .modelContainer(Shared.modelContainer)
    }
}
