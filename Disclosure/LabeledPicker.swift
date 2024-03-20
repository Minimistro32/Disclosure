//
//  LabeledPicker.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/19/24.
//

import SwiftUI

struct LabeledPicker<Value: Hashable & Identifiable>: View {
    var title: String
    var values: [Value]
    @Binding var selection: Value
    var toString: (Value) -> String
    
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
            Picker(title, selection: $selection) {
                ForEach(values) { value in
                    Text(toString(value))
                }
            }
            .pickerStyle(.menu)
        }
        .padding(.leading, 10)
    }
}
