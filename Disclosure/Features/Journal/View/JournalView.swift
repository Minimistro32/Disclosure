//
//  JournalView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/11/24.
//

import SwiftUI

struct JournalView: View {
    @Environment(\.modelContext) var context
    @State private var path = NavigationPath()
    let relapses: [Relapse]
    let entries: [Entry]
    
    private var rollingThreeMonths: [Relapse] {
        relapses.filter {
            $0.date >= Date.now.addingTimeInterval(ChartScale.month.timeInterval * -3)
        }
    }
    private var entriesByRelavance: [Entry] {
        if let latestGoalIndex = entries.firstIndex(where: { $0.isGoal }) {
            var mutableEntries = entries
            let latestGoal = mutableEntries.remove(at: latestGoalIndex)
            mutableEntries.insert(latestGoal, at: 0)
            return mutableEntries
        } else {
            return entries
        }
    }
    
    var body: some View {
        NavigationStack (path: $path) {
            VStack {
                if entries.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No Entries", systemImage: "doc")
                    }, description: {
                        Text("Add goals or write entries to see them here.")
                    }, actions: {
                        HStack(spacing: 40) {
                            Button("New Goal", image: ImageResource(name:"flag.fill.badge.plus", bundle: Bundle.main)) {
                                path.segue(to: .addEntryView, payload: Entry(isGoal: true))
                            }
                            Button("New Entry", systemImage: "plus") {
                                path.segue(to: .addEntryView, payload: Entry(isGoal: false))
                            }
                        }
                    })
                    .offset(y: -40)
                    PrivacyView(description: "Entries remain fully local and private.")
                } else {
                    VStack(spacing: 0) {
                        List {
                            ForEach(entriesByRelavance) { entry in
                                JournalEntry(path: $path, entry: entry)
#if !os(macOS)
                                    .onTapGesture {
                                        path.segue(to: .addEntryView, payload: entry)
                                    }
#endif
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    context.delete(entriesByRelavance[index])
                                }
                            }
                        }
                        .listStyle(.inset)
                        
                        if !rollingThreeMonths.isEmpty {
                            PodiumView(data: rollingThreeMonths)
                        }
                    }
                }
            }
#if !os(macOS)
            .navigationTitle("Journal")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("New Goal", image: ImageResource(name:"flag.fill.badge.plus", bundle: Bundle.main)) {
                        path.segue(to: .addEntryView, payload: Entry(isGoal: true))
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("New Entry", systemImage: "plus") {
                        path.segue(to: .addEntryView, payload: Entry(isGoal: false))
                    }
                }
            }
            .navigationDestination(for: Segue.self) {
                switch $0.destination {
                case .addEntryView:
                    AddEntryView(path: $path, data: rollingThreeMonths, entry: $0.payload as! Entry)
                default:
                    ErrorView(description: "Unaccounted Segue To \($0.destination) ")
                }
            }
#endif
        }
    }
}

struct JournalEntry: View {
    @Environment(\.modelContext) var context
    @Binding var path: NavigationPath
    let entry: Entry
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(entry.title.isEmpty ? entry.type : entry.title)
                    .font(.headline)
                    .contextMenu {
                        Button("Edit", systemImage: "pencil") {
                            path.segue(to: .addEntryView, payload: entry)
                        }
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            context.delete(entry)
                        }
                    }
                Spacer()
                Text(entry.date.formatted(.dateTime.month().day().year()))
                    .font(.caption)
            }
            Text(entry.body)
        }
        .padding()
        .if(entry.isGoal) {
            $0.overlay(
                RoundedRectangle(cornerRadius: 10, style: .circular).stroke(.accent, lineWidth: 3)
            )
        }
    }
}

#Preview {
    JournalView(relapses: SampleData.relapses, entries: [])
}
