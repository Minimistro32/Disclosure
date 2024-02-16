//
//  TrackerView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/3/24.
//

import SwiftUI
import Charts

struct TrackerView: View {
    
    @State private var showLogger = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ChartView().padding()
                HStack {
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
    TrackerView()
}



struct ChartView: View {
    //    let data = MockData.liveJanDayView
    let data = MockData.novemberDayView
    //    let data = MockData.octoberDayView
    
    @State private var rawSelectedDate: Date? = nil
    
    var body: some View {
        Chart {
            ForEach(data) { dayView in
                BarMark(
                    x: .value("Day", dayView.date, unit: .day),
                    y: .value("Count", dayView.count)
                )
                .foregroundStyle(Color.teal.opacity(Double(dayView.intensity) / 10))
            }
            if let rawSelectedDate {
                RuleMark(
                    x: .value("Selected", rawSelectedDate, unit: .day)
                )
                .foregroundStyle(Color.gray.opacity(0.3))
                .offset(yStart: -10)
                .zIndex(-1)
                .annotation(
                    position: .top, spacing: 0,
                    overflowResolution: .init(
                        x: .fit(to: .chart),
                        y: .disabled
                    )
                ) {
                    Rectangle().frame(width: 150, height:100)
                }
            }
        }
        .frame(height: 250)
        .chartYAxis {
            data.reduce(0) { $0 > $1.count ? $0 : $1.count } == 1 ? AxisMarks(values: [0, 1, 2]) : AxisMarks(values: .automatic)
            
        }
        .chartXSelection(value: $rawSelectedDate)
    }
}
