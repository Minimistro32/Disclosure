//
//  ErrorView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/11/24.
//

import SwiftUI

struct ErrorView: View {
    let description: String

    var body: some View {
        VStack {
            ContentUnavailableView("Error", systemImage: "exclamationmark.triangle", description: Text(description))
        }
    }
}

#Preview {
    ErrorView(description: "Test")
}
