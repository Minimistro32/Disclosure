//
//  DisclosureView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/3/24.
//

import SwiftUI
import SwiftData

struct DisclosureView: View {
    @Binding var path: NavigationPath
    let relapse: Relapse
    
    var body: some View {
            TeamListView(data: nil, path: $path, relapse: relapse, editEnabled: false, daysSinceCheckIn: nil)
                .navigationTitle("Disclose Latest")
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

//#Preview {
//    DisclosureView(team: TestData.myTeam, relapse: TestData.spreadsheet.first!)
//}
