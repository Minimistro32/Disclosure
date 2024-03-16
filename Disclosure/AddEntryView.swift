//
//  AddEntryView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/15/24.
//

import SwiftUI

struct AddEntryView: View {
    @Environment(\.modelContext) var context
    @Environment(\.defaultMinListRowHeight) var rowHeight
    @Binding var path: NavigationPath
    let data: [Relapse]
    @Bindable var entry: Entry
    @FocusState private var isFocused: Bool
    
    func customTextEditor(geometry: GeometryProxy) -> some View {
        ZStack(alignment: .leading) {
            if entry.body.isEmpty {
                VStack {
                    Text(entry.isGoal ? "As you set goals, focus on needs and triggers. Remember, pornography and masturbation are a problem, but they aren't THE problem." : "Body")
                        .padding(.init(top: 8, leading: 5, bottom: 0, trailing: 0))
                        .opacity(0.3)
                    Spacer()
                }
            }
            
            TextEditor(text: $entry.body)
                .transaction { transaction in
                    transaction.animation = nil
                }
                .focused($isFocused)
                .frame(minHeight: geometry.size.height-(rowHeight * Double(!isFocused))-77)
                .onChange(of: entry.body) { oldText, newText in
                    let newLineIndex = oldText.lastIndex(where: { $0 == "\n" }) ?? oldText.startIndex
                    if newText.count > oldText.count && newLineIndex < newText.endIndex {
                        if newText[newLineIndex...].starts(with: /\n?•/) {
                            if newText.suffix(3) == "\u{2022} \n"{
                                entry.body.removeLast(3)
                            } else if newText.suffix(1) == "\n" {
                                entry.body.append("\u{2022} ")
                            }
                        }
                    }
                }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            GeometryReader { geometry in
                Form {
                    TextField("Title", text: $entry.title)
                        .focused($isFocused)
                        .font(.title2)
                    customTextEditor(geometry: geometry)
                    if !isFocused {
                        Button {
                            context.insert(entry)
                            path.removeLast()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Submit")
                                Spacer()
                            }
                        }
                    }
                }
                .formStyle(.grouped)
                .navigationTitle("New " + entry.type)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Button("List", systemImage: "list.bullet") { entry.body.append("\u{2022} ") }
                        Spacer()
                        Button("Submit") {
                            entry.date = Date.now
                            context.insert(entry)
                            path.removeLast()
                        }
                        Spacer()
                        Button("Dismiss") { isFocused = false }
                    }
                }
            }
            
            if entry.isGoal && !isFocused {
                PodiumView(data: data)
            }
        }
    }
}
