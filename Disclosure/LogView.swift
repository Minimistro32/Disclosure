//
//  LogView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/15/24.
//

import SwiftUI
import SwiftData

struct LogView: View {
    
    @Environment(\.modelContext) var context
    @State private var showLogger = false
    @State private var showTeam = false
    @State private var relapseToEdit: Relapse?
    //    @Query(sort: \Relapse.date, order: .reverse) var relapses: [Relapse] = []
    let relapses: [Relapse]
    
    var body: some View {
        VStack (spacing: 0) {
            List {
                ForEach(relapses) { relapse in
                    LogCell(relapse: relapse)
                        .onTapGesture {
                            relapseToEdit = relapse
                        }
                    
                    //TODO: Make this dynamic and functional
                    //also make separate sections for relapses to disclose or analyze
                    
                    //Section (header: Text("February 2024")) {
                    //  LogCell(relapse: relapse)
                    //}
                    
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        context.delete(relapses[index])
                    }
                }
            }
            .navigationTitle("Logs")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !relapses.isEmpty {
                    Button("Log Relapse", systemImage: "plus") {
                        showLogger = true
                    }
                }
            }
            
            if !relapses.isEmpty {
                Divider()
                Button {
                    showTeam.toggle()
                } label: {
                    Label("Disclose Latest", systemImage: "person.3")
                }
                .buttonStyle(.borderedProminent)
                .padding()
                //                Divider()
            }
        }
        .background(.debugGray6)
        .fullScreenCover(isPresented: $showLogger) { LoggerView() }
        .fullScreenCover(item: $relapseToEdit) { relapse in
            LoggerView(relapse: relapse)
        }
        .fullScreenCover(isPresented: $showTeam) {
            DisclosureView(relapse: relapses.first!)
        }
        .overlay {
            if relapses.isEmpty {
                ContentUnavailableView(label: {
                    Label("No Relapses", systemImage: "list.bullet.rectangle.portrait")
                }, description: {
                    Text("Log a relapse to see it here.")
                }, actions: {
                    Button("Log Relapse") { showLogger = true }
                })
                .offset(y: -60)
            }
        }
    }
    
}



struct LogCell: View {
    let relapse: Relapse
    
    var body: some View {
        VStack (alignment: .leading, spacing: 5) {
            HStack {
                relapseDateView(date: relapse.date)
                if relapse.reminder {
                    Image(systemName: "bell.fill")
                        .foregroundStyle(.accent)
                }
                Spacer()
                BlahstIconView(selections: relapse.triggers.array)
                    .if(relapse.notes.isEmpty) {
                        $0.padding(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                    }
            }
            
            if !relapse.notes.isEmpty {
                Text(relapse.notes)
                    .opacity(0.5)
                    .lineLimit(3)
            }
        }
    }
}

struct relapseDateView: View {
    let date: Date
    
    var body: some View {
        Text(date,
             format: (date > Date.now.addingTimeInterval(TimeInterval(-1*6.5*24*60*60)) ?
                .dateTime.weekday(.wide).hour().minute() :
                    .dateTime.month(.abbreviated).day(.defaultDigits).hour().minute())
        )
    }
}

//currently unused
//struct SliderIconView: View {
//    let intensity: Int
//    let compulsivity: Int
//
//    var body: some View {
//        HStack (spacing: 2) {
////            Group {
//                Image(systemName: "\(intensity).square.fill")
//                    .foregroundStyle(.intense)
//                Image(systemName: "\(compulsivity).square.fill")
//                    .foregroundStyle(.compulsion)
////            }
//            //not sure how I feel about this actually
////            .opacity(Double(compulsivity) / 12.5 + 0.2)
//        }
//    }
//}

struct BlahstIconView: View {
    let selections: [Bool]
    
    var body: some View {
        HStack(spacing: 2) {
            Spacer()
            ForEach(0 ..< Blahst.expansion.count, id: \.self) { index in
                Image(systemName: "\(Blahst.expansion[index][0].lowercased()).circle\(selections[index] ? ".fill" : "")")
            }
        }
    }
}



#Preview {
    LogView(relapses: TestData.spreadsheet)
}
