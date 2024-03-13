//
//  AddPersonView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/2/24.
//

//https://itnext.io/format-phone-numbers-entirely-in-swiftui-9456f52990a1

import SwiftUI
#if !os(macOS)
import iPhoneNumberField
#endif

enum MessageDrafting: String, Identifiable, CaseIterable {
    var id: Self { return self }
    case automatic = "Automatic"
    case manual = "Manual"
}

struct AddPersonView: View {
    @Environment(\.modelContext) var context
    @Binding var path: NavigationPath
    @Bindable var person: Person = Person()
    @FocusState private var isFocused: Bool
    @State var textingMode: MessageDrafting = .automatic
    @State var personLatestCallProxy: Date?
    //https://stackoverflow.com/questions/69397644/updating-tabview-badge-reloads-all-views-when-using-swiftui-3-badge-modifier
    //use value of `person.latestCall` on init. This field circumvents a bug updating the badge on the team tab bar icon. If the date is changed to update the badge the navigationStack reverts back to the teamView.
    
    //TODO: implement form validation, see LoggerView
    
    var body: some View {
        VStack {
            Form {
                Section("Team Member") {
                    TextField("Name", text: $person.name)
                        .focused($isFocused)
                    Picker("Relationship", selection: $person.relation) {
                        ForEach(Relation.allCases) { relation in
                            Text(relation.rawValue)
                        }
                    }
#if !os(macOS)
                    iPhoneNumberField("Phone", text: $person.phone)
                        .focused($isFocused)
#endif
                }
                
                Section ("Texting") {
                    Toggle("Enable Texting", isOn: $person.canText)
                    if person.canText {
                        Picker("Message Drafting", selection: $textingMode) {
                            ForEach(MessageDrafting.allCases) { mode in
                                Text(mode.rawValue)
                            }
                        }
                    }
                }
                
                if person.canText {
                    if textingMode == .automatic {
                        Section ("Relapse Text") {
                            TextField("Code Word", text: $person.rawCodeWord, prompt: Text("Code Word")) //🦁☠️
                                .focused($isFocused)
                            Text(person.draftText(relapse: Relapse(triggers: [Blahst.expansion[4], Blahst.expansion[5]])))
                                .opacity(0.8)
                        }
                        Section("Triggered Text") {
                            Text(person.draftText())
                                .opacity(0.8)
                        }
                    } else {
                        Section("Manual Text") {
                            TextField("Text Override", text: $person.textOverride, prompt: Text("Type your message..."), axis: .vertical)
                                .lineLimit(1...)
                                .focused($isFocused)
                        }
                    }
                }
                
                //Submit Section
                Section {
                    if person.latestCall != nil {
                        Section {
                            DatePicker("Last Call", selection: $personLatestCallProxy ?? Date.now, in: ...Date())
                        }
                    }
                    
                    Button {
                        person.latestCall = personLatestCallProxy
                        context.insert(person)
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
            .navigationTitle("Add Person")
            
            //            Keyboard Dismiss Button
            Group {
                if isFocused {
                    HStack {
                        Spacer()
                        Button("Dismiss") { isFocused = false }
                    }
                    .padding(.init(top: 7, leading: 0, bottom: 15, trailing: 25))
                }
            }
        }
        .background(.debugGray6)
        
    }
}

struct PreviewTextView: View {
    //    var title: String
    var person: Person
    var relapse: Relapse?
    @Binding var rawCodeWord: String
    @FocusState.Binding var isFocused: Bool
    
    var body: some View {
        TextField("Code Word", text: $rawCodeWord, prompt: Text("Code Word")) //🦁☠️
            .focused($isFocused)
        VStack (alignment: .leading) {
            //            Text("Preview")
            //                .font(.headline)
            //                .padding(.bottom, 1)
            Text(person.draftText(relapse: relapse))
                .opacity(0.8)
        }
    }
}

#Preview("Sponsor") {
    AddPersonView(path: .constant(NavigationPath()), person: TestData.myTeam[0])
}
#Preview {
    AddPersonView(path: .constant(NavigationPath()))
}


