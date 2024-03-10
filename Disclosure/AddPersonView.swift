//
//  AddPersonView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/2/24.
//

//https://itnext.io/format-phone-numbers-entirely-in-swiftui-9456f52990a1

import SwiftUI
import iPhoneNumberField

struct AddPersonView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    @Bindable var person: Person = Person()
    @FocusState private var isPhoneFocused: Bool
    @FocusState private var isNameFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("Team Member") {
                        TextField("Name", text: $person.name)
                            .focused($isNameFocused)
                        Picker("Relationship", selection: $person.relation) {
                            ForEach(Relation.allCases) { relation in
                                Text(relation.rawValue)
                            }
                        }
                        iPhoneNumberField("Phone", text: $person.phone)
                            .focused($isPhoneFocused)
                    }
                    
                    if person.checkInDate != nil {
                        Section {
                            DatePicker("Last Call", selection: $person.checkInDate ?? Date.now, in: ...Date())
                        }
                    }
                    
                    //Submit Section
                    Section {
                        Button {
                            context.insert(person)
                            dismiss()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Submit")
                                Spacer()
                            }
                        }
                    }
                }
                .scrollDisabled(true)
                .toolbar {
                    Button("Add Person", systemImage: "xmark") {
                        dismiss()
                    }
                }
                
                //Keyboard Dismiss Button
                Group {
                    if isPhoneFocused || isNameFocused {
                        HStack {
                            Spacer()
                            Button("Dismiss") {
                                isPhoneFocused = false
                                isNameFocused = false
                            }
                            .padding(.trailing, 10)
                        }
                        .padding(.bottom, 10)
                    }
                }
            }
            .background(.debugGray6)
        }
    }
}

#Preview("Sponsor") {
    AddPersonView(person: TestData.myTeam[0])
}
#Preview {
    AddPersonView()
}


