//
//  DisclosureView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/3/24.
//

import SwiftUI
import SwiftData

struct DisclosureView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \Person.sortValue) private var team: [Person]
    
    @Binding var path: NavigationPath
    let relapse: Relapse
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if team.isEmpty {
                ContentUnavailableView(label: {
                    Label("Why Should I Reach Out?", systemImage: "person.3")
                }, description: {
                    Text("People you trust can help break through shame. They should refocus you on learning from a relapse and meeting needs.")
                }, actions: {
                    Button("Add a Trusted Person") { path.segue(to: .addPersonView) }
                        .buttonStyle(.borderedProminent)
                })
                .offset(y: -60)
                PrivacyView(description: "People added here won't be contacted except by you.")
            } else {
                TeamListView(data: nil, path: $path, relapse: relapse, editEnabled: false, daysSinceCheckIn: nil)
            }
        }
        .navigationTitle("Disclose a Relapse")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    //Possible Navigation Stacks
                    //tracker0 |<- logger1 disclosure2
                    //tracker0 log1 |<- logger2 disclosure3
                    //tracker0 log1 |<- disclosure2 disclosure3
                    
                    path.removeLast(2)
                } label: {
                    Image(systemName: "chevron.left")
                        .bold()
                    Text("Back")
                        .foregroundStyle(.accent)
                }
                .offset(x: -8)
            }
        }
    }
}

#Preview {
    DisclosureView(path: .constant(NavigationPath()), relapse: SampleData.relapses.first!)
}
