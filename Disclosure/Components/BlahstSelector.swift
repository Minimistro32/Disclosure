//
//  BlahstSelector.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/7/24.
//


import SwiftUI

//https://stackoverflow.com/questions/57022615/select-multiple-items-in-swiftui-list
struct BlahstSelector: View {
    @State var items = Blahst.expansion
    @Binding var selections: [Bool]
    
    var body: some View {
        List {
            ForEach(0 ..< items.count, id: \.self) { i in
                BlahstSelectionRow(title: Blahst.expansion[i], isSelected: self.selections[i]) {
                    self.selections[i].toggle()
                }
            }
        }
    }
}

struct BlahstSelectionRow: View {
    //light mode was broken for this one view
    @Environment(\.colorScheme) var colorScheme
    
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                    .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                }
            }
        }
    }
}
