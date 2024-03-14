//
//  DisclosureView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/3/24.
//

import SwiftUI
import SwiftData

struct DisclosureView: View {
    @Query(sort: [SortDescriptor(\Person.sortValue), SortDescriptor(\Person.latestCall)]) var team: [Person] = []
    @Binding var path: NavigationPath
    let relapse: Relapse
    
    var body: some View {
        TeamListView(data: team, path: $path, relapse: relapse, editEnabled: false, daysSinceCheckIn: nil)
            .navigationTitle("Disclose Latest")
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        //TODO: back button has problems if you hit the disclosure button on log view. Needs to go back one view instead of two.
                        path.removeLast(2)
                    } label: {
                        Image(systemName: "chevron.left")
                        Text("Tracker")
                            .foregroundStyle(.accent)
                    }
                }
            }
    }
}

//#Preview {
//    DisclosureView(team: TestData.myTeam, relapse: TestData.spreadsheet.first!)
//}
