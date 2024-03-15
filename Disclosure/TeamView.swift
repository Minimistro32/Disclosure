//
//  TeamView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/2/24.
//

import SwiftUI
import SwiftData
#if !os(macOS)
import MessageUI
#endif

fileprivate func daysSinceToString(_ days: Int) -> String {
    if days == 0 {
        return "Today"
    } else if days == 1 {
        return "1 Day Ago"
    } else {
        return "\(days) Days Ago"
    }
}

struct TeamView: View {
    let data: [Person]
    var daysSinceCheckIn: Int? {
        data.min { $0.daysSinceCall ?? Int.max < $1.daysSinceCall ?? Int.max }?.daysSinceCall
    }
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                VStack (alignment: .leading) {
                    HStack (alignment: .bottom) {
                        if let daysSinceCheckIn {
                            Text("Checked In " + daysSinceToString(daysSinceCheckIn))
#if os(macOS)
                                .font(.largeTitle)
                                .padding(.top)
#else
                                .padding(.leading)
#endif
                                .if(daysSinceCheckIn != 0) {
                                    $0.bold()
                                        .foregroundStyle(.accent)
                                }
                        }
                        
#if os(macOS)
                        Spacer()
                        if !data.isEmpty {
                            LinkButton(title: "Add Person", systemImage: "plus") {
                                path.segue(to: .addPersonView)
                            }
                        }
#endif
                    }
                    
                    if !data.isEmpty {
                        TeamListView(data: data, path: $path, relapse: nil, daysSinceCheckIn: daysSinceCheckIn)
                    }
                }
            }
#if os(macOS)
            .frame(maxWidth: 425)
#else
            .navigationTitle("Team")
            .toolbar {
                if !data.isEmpty {
                    Button("Add Person", systemImage: "plus") {
                        path.segue(to: .addPersonView)
                    }
                }
            }
#endif
            .navigationDestination(for: Segue.self) {
                if let person = $0.payload as? Person {
                    AddPersonView(path: $path, person: person, personLatestCallProxy: person.latestCall)
                } else {
                    AddPersonView(path: $path)
                }
            }
            
            if data.isEmpty {
                ContentUnavailableView(label: {
                    Label("Recovery is a Team Effort", systemImage: "person.3")
                }, description: {
                    Text("Disclosure intends to make reaching out\nto your team easier. People added here won't be contacted except by you.")
                }, actions: {
                    Button("Add a Trusted Person") { path.segue(to: .addPersonView) }
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
    @State private var selection = Set<Person.ID>()
    let relapse: Relapse?
    var editEnabled: Bool = true
    let daysSinceCheckIn: Int?
    
    var body: some View {
        List(selection: $selection) {
            ForEach(Relation.allCases) { relation in
                let relationData = data.filter({ $0.relation == relation})
                if !relationData.isEmpty {
                    Section(header: Text(relation.rawValue)) {
                        teamRow(relation: relation, relationData: relationData)
                    }
                }
            }
        }
#if os(macOS)
        .listStyle(.bordered)
#endif
        .contextMenu(forSelectionType: Person.ID.self) { ids in
            if ids.isEmpty {
                Button("New Person", systemImage: "plus") {
                    path.segue(to: .addPersonView)
                }
            } else {
                let people = data.filter { ids.contains($0.id) }
                if ids.count == 1 {
                    Button("Edit", systemImage: "pencil") {
                        path.segue(to: .addPersonView, payload: people.first!)
                    }
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        context.delete(people.first!)
                    }
                } else {
                    Button("Delete Selected", systemImage: "trash", role: .destructive) {
                        for person in people {
                            context.delete(person)
                        }
                    }
                }
            }
        }
    }
    
    func teamRow(relation: Relation, relationData: [Person]) -> some View {
        return ForEach(relationData) { person in
            PersonView(path: $path, person: person, relapse: relapse, daysSinceCheckIn: daysSinceCheckIn)
                .onTapGesture {
                    if editEnabled {
                        path.segue(to: .addPersonView, payload: person)
                    }
                }
        }
        .if(editEnabled) {
            $0.onDelete { indexSet in
                for index in indexSet {
                    context.delete(data.filter { $0.relation == relation }[index])
                }
            }
        }
    }
}


struct PersonView: View {
    @Environment(\.modelContext) var context
    @Binding var path: NavigationPath
    let person: Person
    let relapse: Relapse?
    let daysSinceCheckIn: Int?
    
#if os(macOS)
    var body: some View {
        HStack (spacing: 25) {
            Text(person.name)
                .bold()
                .contextMenu {
                    Button("Edit", systemImage: "pencil") {
                        Segue.perform(with: &path, to: .addPersonView, payload: person)
                    }
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        context.delete(person)
                    }
                }
            
            Spacer()
            
            if let daysSince = person.daysSinceCall {
                Text(daysSinceToString(daysSince))
            }
            
//            Group {
//                if person.canText {
//                    Image(systemName: "message.fill")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                }
//                Image(systemName: "phone.fill")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .padding(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
//                    .if(daysSinceCheckIn != 0) {
//                        $0.bold()
//                            .foregroundStyle(.accent)
//                    }
//            }
//            .frame(width: 30)
        }
        .if(person.daysSinceCall == nil) {
            $0.padding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .padding(.init(top: 5, leading: 15, bottom: 5, trailing: 15))
    }
#else
    private let messageComposeDelegate = MessageComposerDelegate()
    
    var body: some View {
        HStack (spacing: 25) {
            VStack (alignment: .leading) {
                
                Text(person.name)
                    .bold()
                    .contextMenu {
                        Button("Edit", systemImage: "pencil") {
                            path.segue(to: .addPersonView, payload: person)
                        }
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            context.delete(person)
                        }
                    }
                
                if let daysSince = person.daysSinceCall {
                    Text(daysSinceToString(daysSince))
                }
            }
            Spacer()
            Group {
                if person.canText {
                    Image(systemName: "message.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .onTapGesture {
                            self.presentMessageCompose(person: person, relapse: relapse)
                        }
                    
                }
                Image(systemName: "phone.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                    .onTapGesture {
                        guard let url = URL(string: "tel://" + person.phone) else { return }
                        UIApplication.shared.open(url)
                        person.latestCall = Date.now
                        if path.count > 0 {
                            path.removeLast(2)
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
#endif
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

#if !os(macOS)
// MARK: The message extension
extension PersonView {
    private class MessageComposerDelegate: NSObject, MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            // Customize here
            controller.dismiss(animated: true)
        }
    }
    /// Present an message compose view controller modally in UIKit environment
    private func presentMessageCompose(person: Person, relapse: Relapse?) {
        guard MFMessageComposeViewController.canSendText() else {
            print(person.draftText(relapse: relapse))
            return
        }
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let vc = windowScene?.windows.filter {$0.isKeyWindow}.first?.rootViewController
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = messageComposeDelegate
        
        composeVC.recipients = [person.phone]
        composeVC.body = person.draftText(relapse: relapse)
        
        vc?.present(composeVC, animated: true)
    }
}
#endif

