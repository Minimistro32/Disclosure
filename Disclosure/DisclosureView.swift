//
//  DisclosureView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/3/24.
//

import SwiftUI
import SwiftData

struct DisclosureView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: [SortDescriptor(\Person.sortValue), SortDescriptor(\Person.checkInDate)]) var team: [Person] = []
    let relapse: Relapse
    
    var body: some View {
        NavigationStack {
            VStack {
                TeamListView(data: team, toEdit: .constant(nil), editEnabled: false, daysSinceCheckIn: nil)
            }
            .navigationTitle("Disclose To")
            .toolbar {
                Button("Cancel", systemImage: "xmark") {
                    dismiss()
                }
            }
        }
    }
}

//#Preview {
//    DisclosureView(team: TestData.myTeam, relapse: TestData.spreadsheet.first!)
//}
