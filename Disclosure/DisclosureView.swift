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
                ToolbarItem(placement: .cancellationAction) { //was topBarLeading before mac interop was enabled
                    Button {
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
