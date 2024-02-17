//
//  TrackerView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/3/24.
//

import SwiftUI
import Charts
import SwiftData

enum ChartScale: String, CaseIterable, Identifiable {
    case week = "Week"
    case month = "Month"
    case threeMonth = "3 Months"
    case year = "Year"
    
    var id: Self { return self}
}

struct TrackerView: View {
    
    @Query(sort: \Relapse.date, order: .reverse) var data: [Relapse] = []
    @State private var showLogger = false
    @State private var selectedChartScale = ChartScale.week
    
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
                
                ChartView(scale: selectedChartScale, data: data).padding()
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
    
    @State private var rawSelectedDate: Date? = nil
    @State private var scrollPosition: TimeInterval
    var selectionIndex: Int? {
        if let rawSelectedDate {
            return ((
                    Int(Date.now.addingTimeInterval(scrollPosition).timeIntervalSince1970) - Int(rawSelectedDate.timeIntervalSince1970)
                    ) / 86400
                 ) - 8440
        } else {
            return nil
        }
    }
    let data: [Relapse]
    let scale: ChartScale
    let visibleDays: Int
    let visibleSeconds: Double
    let chartHeight: CGFloat = 250
    
    init(scale: ChartScale, data: [Relapse]) {
        self.scale = scale
        self.data = data
        //        self._rawSelectedDate = State(initialValue: nil)
        
        let scaleDays = switch scale {
        case ChartScale.week:
            7
        case ChartScale.month:
            31
        case ChartScale.threeMonth:
            30*3
        case ChartScale.year:
            365
        }
        
        self.visibleDays = min(
            scaleDays,
            //86400 sec = 1 day
            Int(ceil((data.max{ $0.date > $1.date }?.date.timeIntervalSinceNow ?? 86400) / -86400))
        )
        self.visibleSeconds = 60 * 60 * 24 * Double(visibleDays)
        
        self._scrollPosition = State(initialValue: Date.now.addingTimeInterval(-1 * visibleSeconds).timeIntervalSinceReferenceDate)
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
//                Text("\(CGFloat(visibleDays))")
                Text(String(selectionIndex ?? -1))
            }
            if let rawSelectedDate {
//                Text("\(scrollPosition)").offset(
//                    x: (UIScreen.main.bounds.size.width / CGFloat(visibleDays))
//                    *
//                    ((rawSelectedDate - scrollPosition).timeIntervalSince1970 / 86400),
//                    y: chartHeight / -2
//                )
            }
            
            Chart {
                ForEach(data) { relapse in
                    BarMark(
                        x: .value("Day", relapse.date, unit: .day),
                        y: .value("Count", 1)
                    )
                    //                .foregroundStyle(Color.intense.opacity(Double(relapse.intensity) / 10))
                    //                .foregroundStyle(Color.compulsion.opacity(Double(relapse.compulsivity) / 10))
                    //                .foregroundStyle(.accent)
                }
                if let rawSelectedDate {
                    RuleMark(
                        x: .value("Selected", rawSelectedDate, unit: .day)
                    )
                    .foregroundStyle(Color.gray.opacity(0.3))
                    .offset(yStart: -10)
                    .zIndex(-1)
                    //                //broken by chartScrollableAxes(...)
                    //                .annotation(
                    //                    position: .top, spacing: 0,
                    //                    overflowResolution: .init(
                    //                        x: .fit(to: .chart),
                    //                        y: .disabled
                    //                    )
                    //                ) {
                    //                    Rectangle().foregroundStyle(.red).frame(width: 150, height:100)
                    //                }
                }
            }
            .frame(height: chartHeight)
            .chartScrollableAxes(.horizontal)
            .chartXVisibleDomain(length: visibleSeconds)
            .chartScrollTargetBehavior(
                .valueAligned(matching: .init(hour: 0),
                              majorAlignment: .matching(.init(day: 1))
                             )
            )
            .chartScrollPosition(x: $scrollPosition)
            .chartXAxis {
                if scale == ChartScale.week {
                    AxisMarks(values: .automatic(desiredCount: visibleDays)) { value in
                        if let date = value.as(Date.self) {
                            if date > Date.now.addingTimeInterval(-1 * visibleSeconds) {
                                AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                            } else {
                                AxisValueLabel(format: .dateTime.month(.abbreviated).day(.defaultDigits))
                            }
                            
                            AxisGridLine()
                            AxisTick()
                        }
                    }
                } else {
                    AxisMarks(
                        values: .automatic()
                    )
                }
            }
            .chartXSelection(value: $rawSelectedDate)
            .border(.red)
        }
    }
}
