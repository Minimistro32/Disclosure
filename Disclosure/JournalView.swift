//
//  JournalView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/11/24.
//

import SwiftUI

struct JournalView: View {
    let data: [Relapse]
    
    private var rollingThreeMonths: [Relapse] {
        data.filter {
            $0.date >= Date.now.addingTimeInterval(ChartScale.month.timeInterval * -3)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if !rollingThreeMonths.isEmpty {
                    PodiumView(data: rollingThreeMonths)
                    Spacer()
                }
                List {
                    JournalEntry(isGoal: true)
                    JournalEntry(isGoal: false)
                }
                .listStyle(.inset)
            }
#if !os(macOS)
            .navigationTitle("Journal")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("New Goal", image: ImageResource(name:"flag.fill.badge.plus", bundle: Bundle.main)) {
                        print("new entry")
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("New Entry", systemImage: "plus") {
                        print("new")
                    }
                }
            }
#endif
        }
    }
}

struct JournalEntry: View {
    let isGoal: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Goal Title")
                    .font(.headline)
                Spacer()
                Text(Date.now.formatted(.dateTime.month().day().year()))
                    .font(.caption)
            }
            Text("Other entries loreum ipsum Other entries loreum ipsum Other entries loreum ipsum Other entries loreum ipsum Other entries loreum ipsum Other entries loreum ipsum Other entries loreum ipsum Other entries loreum ipsum ")
        }
        .padding()
        .if(isGoal) {
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
        print()
        print(valuatedTriggers)
        print(Blahst.expansion)
        let result = zip(Blahst.expansion, valuatedTriggers).sorted { $0.1 > $1.1 }.map { $0.0 }
        print(result)
        return result
    }
    
    var body: some View {
        VStack {
            HStack (spacing: 25) {
                ForEach(0..<3) { i in
                    HStack {
                        Image(systemName: "\(i + 1).circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text(triggersBySalience[i])
                    }
                }
            }
            .padding(.top)
            Text(selectedLens == .frequency ? "These triggers appear most frequently." : "These triggers are correlated with strong urges.")
                .font(.caption)
                .padding(.bottom, 5)
            Picker("Ranked by", selection: $selectedLens) {
                ForEach(PodiumLens.allCases) { lens in
                    Text(lens.rawValue)
                }
            }
            .pickerStyle(.navigationLink)
            .frame(width: 190)
        }
    }
}

#Preview {
    JournalView(data: TestData.spreadsheet)
}
