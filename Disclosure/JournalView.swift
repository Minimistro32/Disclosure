//
//  JournalView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/11/24.
//

import SwiftUI

struct JournalView: View {
    @Environment(\.modelContext) var context
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
        NavigationStack {
            VStack(spacing: 0) {
                List {
                    ForEach(entriesByRelavance) { entry in
                        JournalEntry(entry: entry)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            context.delete(entriesByRelavance[index])
                        }
                    }
                }
                .listStyle(.inset)
                .overlay {
                    if entries.isEmpty {
                        ContentUnavailableView(label: {
                            Label("No Entries", systemImage: "doc")
                        }, description: {
                            Text("Add goals or write entries to see them here.")
                        }, actions: {
                            HStack(spacing: 40) {
                                Button("New Goal") {
                                    //                                path.segue(to: .loggerView)
                                }
                                Button("New Entry") {
                                    //                                path.segue(to: .loggerView)
                                }
                            }
                        })
                        .offset(y: -30)
                    }
                }
                
                if !rollingThreeMonths.isEmpty {
                    Divider()
                    PodiumView(data: rollingThreeMonths)
                        .padding(.bottom, 15)
                }
            }
#if !os(macOS)
            .navigationTitle("Journal")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("New Goal", image: ImageResource(name:"flag.fill.badge.plus", bundle: Bundle.main)) {
                        print("new entry")
                        context.insert(Entry(title: "MyGoal", body: "Goal", isGoal: true))
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("New Entry", systemImage: "plus") {
                        print("new")
                        context.insert(Entry(title: "MyNote", body: "Note"))
                    }
                }
            }
#endif
        }
    }
}

struct JournalEntry: View {
    @Environment(\.modelContext) var context
    let entry: Entry
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(entry.title)
                    .font(.headline)
                    .contextMenu {
                        Button("Edit", systemImage: "pencil") {
//                            Segue.perform(with: &path, to: .addPersonView, payload: person)
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

struct PodiumView: View {
    @State var selectedLens: PodiumLens = .frequency
    let data: [Relapse]
    
    enum PodiumLens: String, CaseIterable, Identifiable {
        var id: Self { return self }
        case frequency = "Frequency"
        case compulsivity = "Compulsivity"
    }
    
    private func aggregateTriggers(by: PodiumLens) -> [Double] {
        data.map { relapse in
            relapse.triggers.array.map { trigger in
                Double(trigger) * (by == .compulsivity ? Double(relapse.compulsivity) : 1) //map triggers to integer values
            }
        }.reduce(.init(repeating: 0, count: Blahst.expansion.count)) { prevResult, triggers in
            zip(prevResult, triggers).map { $0.0 + $0.1 } //sum up
        }
    }
    
    private var valuatedTriggers: [Double] {
        switch selectedLens {
        case .compulsivity: //average compulsivity
            zip(aggregateTriggers(by: .compulsivity), aggregateTriggers(by: .frequency)).map({
                $0.0 / ($0.1 == 0 ? 1 : $0.1)
            })
        default: //total occurences
            aggregateTriggers(by: .frequency)
        }
    }
    
    private var triggersBySalience: [String] {
        zip(Blahst.expansion, valuatedTriggers).sorted { $0.1 > $1.1 }.map { $0.0 }
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                ForEach(0..<3) { i in
                    HStack {
                        Image(systemName: "\(i + 1).circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text(triggersBySalience[i])
                    }
                    Spacer()
                }
            }
            .padding(.top)
            Text(selectedLens == .frequency ? "These triggers appear most frequently." : "These triggers are correlated with strong urges.")
                .font(.caption)
                .padding(.bottom, 5)
            HStack(spacing: 0) {
                Spacer()
                Text("Ranked by")
                Picker("Ranked by", selection: $selectedLens) {
                    ForEach(PodiumLens.allCases) { lens in
                        Text(lens.rawValue)
                    }
                }
                .pickerStyle(.menu)
                Spacer()
            }
        }
    }
}

#Preview {
    JournalView(relapses: TestData.spreadsheet, entries: [])
}
