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
    @Binding var path: NavigationPath
    let relapses: [Relapse]
    
    var body: some View {
        VStack {
#if os(macOS)
            HStack {
                Text("Logs")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                LinkButton(title: "Back", systemImage: "chevron.left") {
                    path.removeLast()
                }
                LinkButton(title: "Log Relapse", systemImage: "plus") {
                    path.append(Segue(to: .loggerView))
                }
            }
            .padding(.top)
#endif
            
            List {
                ForEach(relapses) { relapse in
                    LogCell(relapse: relapse)
                        .onTapGesture {
                            path.append(Segue(to: .loggerView, payload: relapse))
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
#if os(macOS)
            .navigationBarBackButtonHidden(true)
#else
            .navigationTitle("Logs")
            .toolbar {
                if !relapses.isEmpty {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            path.append(Segue(to: .disclosureView, payload: relapses.first!))
                        } label: {
                            Label("Disclose Latest", systemImage: "person.3")
                        }
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    if !relapses.isEmpty {
                        Button("Log Relapse", systemImage: "plus") {
                            path.append(Segue(to: .loggerView))
                        }
                    }
                }
            }
#endif
        }
#if !os(macOS)
        .background(.debugGray6)
#endif
        .overlay {
            if relapses.isEmpty {
                ContentUnavailableView(label: {
                    Label("No Relapses", systemImage: "list.bullet.rectangle.portrait")
                }, description: {
                    Text("Log a relapse to see it here.")
                }, actions: {
                    Button("Log Relapse") {
                        path.append(Segue(to: .loggerView))
                    }
                })
                .offset(y: -60)
            }
        }
    }
    
}



struct LogCell: View {
    let relapse: Relapse
    
#if os(macOS)
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                relapseDateView(date: relapse.date)
                if relapse.reminder {
                    Image(systemName: "bell.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15)
                        .foregroundStyle(.accent)
                }
                
                
                BlahstIconView(selections: relapse.triggers.array, size: 25)
                    .padding(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
            }
            if !relapse.notes.isEmpty {
                Text(relapse.notes)
                    .lineLimit(5)
                    .padding(.leading, 175)
                    .padding(.trailing, 180)
            }
        }
    }
#else
    var body: some View {
        VStack (alignment: .leading, spacing: 5) {
            HStack {
                relapseDateView(date: relapse.date)
                if relapse.reminder {
                    Image(systemName: "bell.fill")
                        .foregroundStyle(.accent)
                }
                Spacer()
                BlahstIconView(selections: relapse.triggers.array, size: 20)
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
#endif
    
}

struct relapseDateView: View {
    let date: Date
    var body: some View {
        Text(date,
             format: (date > Date.now.addingTimeInterval(TimeInterval(-1*6.5*24*60*60)) ?
                .dateTime.weekday(.wide).hour().minute() :
                    .dateTime.month(.abbreviated).day(.defaultDigits).hour().minute())
        )
#if os(macOS)
        .font(.title3)
#endif
    }
}

struct BlahstIconView: View {
    let selections: [Bool]
    let size: CGFloat
    var body: some View {
        HStack(spacing: 2) {
            Spacer()
            ForEach(0 ..< Blahst.expansion.count, id: \.self) { index in
                Image(systemName: "\(Blahst.expansion[index][0].lowercased()).circle\(selections[index] ? ".fill" : "")")
                    .resizable()
                    .frame(width: size, height: size)
            }
        }
    }
}


//
//#Preview {
//    LogView(relapses: TestData.spreadsheet)
//}
