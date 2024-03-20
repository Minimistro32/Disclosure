//
//  PodiumView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/15/24.
//

import SwiftUI

struct PodiumView: View {
    @State var selectedLens: PodiumLens = .frequency
    let data: [Relapse]
    
    enum PodiumLens: String, CaseIterable, Identifiable {
        var id: Self { return self }
        case frequency = "Frequency"
        case compulsivity = "Urges"
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
        Divider()
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
            LabeledPicker(title: "Ranked by", values: PodiumLens.allCases, selection: $selectedLens) {
                $0.rawValue
            }
        }
        .padding(.bottom, 15)
    }
}
