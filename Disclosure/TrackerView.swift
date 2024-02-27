//
//  TrackerView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/3/24.
//

import SwiftUI
import SwiftData


struct TrackerView: View {
    let data: [Relapse]
    @State private var showLogger = false
    @State private var selectedChartScale = ChartScale.week
    @State private var selectedChartLens = ChartLens.none
    @State private var rawSelectedDate: Date? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker(selection: $selectedChartScale) {
                    ForEach(ChartScale.allCases) { interval in
                        Text(interval.rawValue)
                    }
                } label: {
                    Text("Time Interval for Chart")
                }
                .pickerStyle(.segmented)
                .padding()
                .opacity(rawSelectedDate == nil ? 1.0 : 0.0)
                
                ChartView(rawSelectedDate: $rawSelectedDate, data: data, scale: selectedChartScale, lens: selectedChartLens).padding()
                HStack {
                    Picker(selection: $selectedChartLens) {
                        ForEach(ChartLens.allCases) { lens in
                            Text(lens.rawValue)
                        }
                    } label: {
                        Text("View")
                    }
                    .pickerStyle(.navigationLink)
                    .padding(.leading)
                    .frame(maxWidth: 170)
                    
                    Spacer()
                    
                    NavigationLink (destination: LogView(), label: {
                        Label("More", systemImage: "ellipsis.circle")
                    })
                    .padding(.trailing)
                }
                
                Spacer()
                
                Button {
                    showLogger.toggle()
                } label: {
                    Label("Log Relapse", systemImage: "arrow.counterclockwise")
                }
            }
            .navigationTitle("Tracker")
        }
        .sheet(isPresented: $showLogger) {
            LoggerView()
        }
    }
}

#Preview {
    TrackerView(data: TestData.spreadsheet)
}


