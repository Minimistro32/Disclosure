//
//  LinkButton.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/13/24.
//

import SwiftUI

struct LinkButton: View {
    var title: String
    var systemImage: String
    let action: () -> Void
    
    var body: some View {
        Button(title, systemImage: systemImage, action: action)
#if os(macOS)
            .buttonStyle(.link)
            .foregroundStyle(.accent)
#endif
            .padding(.init(top: 7, leading: 10, bottom: 7, trailing: 10))
            .background(.gray.opacity(0.2), in: .buttonBorder, fillStyle: FillStyle(eoFill: false, antialiased: false))
    }
}
