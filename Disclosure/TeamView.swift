//
//  TeamView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/2/24.
//

import SwiftUI
import MessageUI

//TODO: Investigate using navigationPath array (from NavigationStack) to pop off LoggerView and replace it with a DisclosureView built from an ineditable TeamListView.

struct TeamView: View {
    let data: [Person]
    var daysSinceCheckIn: Int? {
        data.min { $0.daysSinceCheckIn ?? Int.max < $1.daysSinceCheckIn ?? Int.max}?.daysSinceCheckIn
    }
    @State private var path = NavigationPath()
    @State private var showAddPerson = false
    @State private var personToEdit: Person?
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack (alignment: .leading) {
                    if let daysSinceCheckIn {
                        Text("Checked In " + daysSinceToString(daysSinceCheckIn))
                            .padding(.leading)
                            .if(daysSinceCheckIn != 0) {
                                $0.bold()
                                .foregroundStyle(.accent)
                            }
                    }
                    if !data.isEmpty {
                        TeamListView(data: data, path: $path, daysSinceCheckIn: daysSinceCheckIn)
                    }
                }
            }
            .navigationTitle("Team")
            .toolbar {
                if !data.isEmpty {
                    Button("Add Person", systemImage: "plus") {
                        showAddPerson = true
                    }
                }
            }
            .fullScreenCover(isPresented: $showAddPerson) {
                AddPersonView()
                    .presentationDetents([.medium])
            }
            .navigationDestination(for: Person.self) {
                AddPersonView(person: $0)
            }
//            .fullScreenCover(item: $personToEdit) { person in
//            }
            
            if data.isEmpty {
                ContentUnavailableView(label: {
                    Label("Recovery is a Team Effort", systemImage: "person.3")
                }, description: {
                    Text("Disclosure intends to make reaching out\nto your team easier. People added here won't be contacted except by you.")
                }, actions: {
                    Button("Add a Trusted Person") { showAddPerson = true }
                })
                .offset(y: -60)
            }
        }
    }
}


struct TeamListView: View {
    @Environment(\.modelContext) var context
    let data: [Person]
    @Binding var path: NavigationPath
    var editEnabled: Bool = true
    let daysSinceCheckIn: Int?
    
    var body: some View {
        List {
            ForEach(Relation.allCases) { relation in
                let relationData = data.filter({ $0.relation == relation})
                if !relationData.isEmpty {
                    Section(header: Text(relation.rawValue)) {
                        ForEach(relationData) { person in
                            PersonView(path: $path, person: person, daysSinceCheckIn: daysSinceCheckIn)
                                .onTapGesture {
                                    if editEnabled {
                                        path.append(person)
                                    }
                                }
                        }
                        .if(editEnabled) {
                            $0.onDelete { indexSet in
                                for index in indexSet {
                                    context.delete(data.filter {$0.relation == relation}[index])
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

fileprivate func daysSinceToString(_ days: Int) -> String {
    if days == 0 {
        return "Today"
    } else if days == 1 {
        return "1 Day Ago"
    } else {
        return "\(days) Days Ago"
    }
}

struct PersonView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var path: NavigationPath
    let person: Person
    let daysSinceCheckIn: Int?
    private let messageComposeDelegate = MessageComposerDelegate()
    
    var body: some View {
        HStack (spacing: 25) {
            VStack (alignment: .leading) {
                Text(person.name)
                    .bold()
                if let daysSince = person.daysSinceCheckIn {
                    Text(daysSinceToString(daysSince))
                }
            }
            Spacer()
            Group {
                if person.relation == .sponsor {
                    Image(systemName: "message.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .onTapGesture {
                            self.presentMessageCompose(person: person)
                        }
                    
                }
                Image(systemName: "phone.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                    .onTapGesture {
                        guard let url = URL(string: "tel://" + person.phone) else { return }
                        UIApplication.shared.open(url)
                        person.checkInDate = Date.now
                        if path.count > 0 {
                            dismiss()
                        }
                    }
                    .if(daysSinceCheckIn != 0) {
                        $0.bold()
                        .foregroundStyle(.accent)
                    }
            }
            .frame(width: 30)
        }
    }
}

#Preview {
    TeamView(data: TestData.myTeam)
}
#Preview("Empty TeamView") {
    TeamView(data: [])
}
//#Preview("TeamListView") {
//    TeamListView(data: TestData.myTeam, daysSinceCheckIn: 0)
//}

// MARK: The message extension
extension PersonView {
    
    private class MessageComposerDelegate: NSObject, MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            // Customize here
            controller.dismiss(animated: true)
        }
    }
    /// Present an message compose view controller modally in UIKit environment
    private func presentMessageCompose(person: Person) {
        guard MFMessageComposeViewController.canSendText() else {
            print("presentMessageCompose \(person.name)")
            return
        }
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let vc = windowScene?.windows.filter {$0.isKeyWindow}.first?.rootViewController
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = messageComposeDelegate
        
        composeVC.recipients = [person.phone]
        composeVC.body = "DEBUG_TEST: Hey " + String(person.name.split(separator: " ").first ?? "") + ", 🦁☠️. I was hungry and bored. I want to learn from this for next time. Can I talk through it with you?"
        
        vc?.present(composeVC, animated: true)
    }
}
