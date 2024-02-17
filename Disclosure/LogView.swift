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
    @State private var relapseToEdit: Relapse?
    
    var body: some View {
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
        .sheet(isPresented: $showLogger) { LoggerView() }
        .sheet(item: $relapseToEdit) { relapse in
            LoggerView(relapse: relapse)
        }
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
        VStack (alignment: .leading, spacing: 4) {
            HStack {
                relapseDateView(date: relapse.date)
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    SliderIconView(intensity: relapse.intensity, compulsivity: relapse.compulsivity)
                    BlahstIconView(selections: relapse.triggers.array)
                }
            }
            
            if !relapse.notes.isEmpty {
                Text(relapse.notes)
                    .opacity(0.5)
                    .lineLimit(2)
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

struct SliderIconView: View {
    let intensity: Int
    let compulsivity: Int
    
    var body: some View {
        HStack (spacing: 2) {
            Group {
                Image(systemName: "\(intensity).square.fill")
                    .foregroundStyle(.intense)
                Image(systemName: "\(compulsivity).square.fill")
                    .foregroundStyle(.compulsion)
            }
            .opacity(Double(compulsivity) / 12.5 + 0.2)
        }
    }
}

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
    LogView()
}
