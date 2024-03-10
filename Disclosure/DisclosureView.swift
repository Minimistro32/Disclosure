//
//  DisclosureView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/3/24.
//

import SwiftUI
import SwiftData

struct DisclosureView: View {
    @Query(sort: [SortDescriptor(\Person.sortValue), SortDescriptor(\Person.checkInDate)]) var team: [Person] = []
    @Binding var path: NavigationPath
    let relapse: Relapse
    let fromLogger: Bool
    
//    init(path: NavigationPath, relapse: Relapse, fromLogger: Bool) {
//        self.path = path
//        self.relapse = relapse
//        self.fromLogger = fromLogger
//    }
    
    var body: some View {
        TeamListView(data: team, path: $path, editEnabled: false, daysSinceCheckIn: nil)
            .navigationTitle("Disclose " + (fromLogger ? "To" : "Latest"))
    }
}

//#Preview {
//    DisclosureView(team: TestData.myTeam, relapse: TestData.spreadsheet.first!)
//}
