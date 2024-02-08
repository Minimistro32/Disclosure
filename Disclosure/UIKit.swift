//
//  UIKit.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/7/24.
//

import SwiftUI

//https://stackoverflow.com/questions/57022615/select-multiple-items-in-swiftui-list
struct MultipleSelectionList: View {
    @State var items: [String] = ["Apples", "Oranges", "Bananas", "Pears", "Mangos", "Grapefruit"]
    @Binding var selections: [String]
    
    var body: some View {
        List {
            ForEach(self.items, id: \.self) { item in
                MultipleSelectionRow(title: item, isSelected: self.selections.contains(item)) {
                    if self.selections.contains(item) {
                        self.selections.removeAll(where: { $0 == item })
                    }
                    else {
                        self.selections.append(item)
                    }
                }
            }
        }
        
    }
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
