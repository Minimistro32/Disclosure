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
    @Query(sort: \Relapse.date, order: .reverse) var relapses: [Relapse] = []
    
    var body: some View {
        List {
            ForEach(relapses) { relapse in
                LogCell(relapse: relapse)
                
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
        .sheet(isPresented: $showLogger) { LoggerView() }
        .toolbar {
            if !relapses.isEmpty {
                Button("Log Relapse", systemImage: "plus") {
                    showLogger = true
                }
            }
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
        HStack (spacing: 10) {
//            VStack (spacing: 5) {
//                if relapse.reminder {
//                    Image(systemName: "bell.fill")
//                        .foregroundStyle(.red)
//                }
//                if !relapse.disclosed {
//                    Image(systemName: "phone.fill")
//                        .foregroundStyle(.green)
//                }
//            }
            VStack (spacing: 5) {
                HStack {
                    Text(relapse.date,
                         format: (relapse.date > Date.now.addingTimeInterval(TimeInterval(-1*7*24*60*60)) ?
                            .dateTime.weekday(.wide).hour().minute() :
                                .dateTime.weekday(.abbreviated).day(.defaultDigits).hour().minute())
                    )
                    Spacer()
                    ForEach(0 ..< Blahst.list.count, id: \.self) { index in
                        Image(systemName: "\(Blahst.list[index][0].lowercased()).circle\(relapse.triggers.list[index] ? ".fill" : "")")
                    }
                }
                //                HStack{
                //                    Spacer()
                //                }
                if !relapse.notes.isEmpty {
                    Text(relapse.notes)
                        .opacity(0.5)
                        .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                }
            }
        }
    }
}


#Preview {
    LogView()
}
