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
    @State private var selectedChartLens = ChartLens.previous//none
    @State private var rawSelectedDate: Date? = nil
    private var lensPickerWidth: CGFloat {
        switch selectedChartLens {
        case .none:
            108.0
        case .compulsion:
            155.0
        default:
            130.0
        }
    }
    private var averageStreak: Int {
        //three month average streak
        let rollingThreeMonthCount = data.filter {
            ChartScale.threeMonth.containsDate($0.date)
        }.count
        
        if rollingThreeMonthCount == 0 {
            return 0
        } else {
            return ChartScale.threeMonth.domain / rollingThreeMonthCount
        }
    }
    private var currentStreak: Int {
        return Int((data.max(by: { $0.date < $1.date })?.date.timeIntervalSinceNow ?? 0) / (-24*60*60))
    }
    
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
                    .frame(maxWidth: lensPickerWidth)
                    
                    Spacer()
                    
                    NavigationLink (destination: LogView(), label: {
                        Label("More", systemImage: "ellipsis.circle")
                    })
                    .padding(.trailing)
                }
                
                Spacer()
                
                HStack {
                    MetricView(count: averageStreak,
                               name: "Average Streak")
                        .padding(.leading, 40)
                    Spacer()
                    MetricView(count: currentStreak, name: "Days Sober")
                        .padding(.trailing, 40)
                }
                
                Spacer()
                
                Button {
                    showLogger.toggle()
                } label: {
                    Label("Log Relapse", systemImage: "arrow.counterclockwise")
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
            }
            .navigationTitle("Tracker")
        }
        .sheet(isPresented: $showLogger) {
            LoggerView()
        }
    }
}

struct MetricView: View {
    let count: Int
    let name: String
    
    var body: some View {
        VStack {
            HStack {
                Text(String(count))
                    .font(.system(size: 70))
                Text("Days")
            }
            Text(name)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    TrackerView(data: TestData.spreadsheet)
}


