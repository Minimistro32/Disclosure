//
//  ChartView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/27/24.
//

//TODO: FIX incorrect bars vs actual data and annotation
//TODO: FIX Lag on annotation?
//TODO: FIX jank on date on right side


import SwiftUI
import Charts

struct ChartView: View {
    
    @Binding var rawSelectedDate: Date?
    let data: [Relapse]
    let scale: ChartScale
    let lens: ChartLens
    let chartHeight: CGFloat = 250
    
    var gradedData: [Relapse] {
        //visibleData
        let visibleData = data.filter { relapse in
            relapse.date > (lens == .previous ? scale.previousDate : scale.startDate)
        }
        if lens.isGraded {
            return visibleData.sorted { relapse1, relapse2 in
                if lens == .intensity {
                    relapse1.intensity > relapse2.intensity
                } else {
                    relapse1.compulsivity > relapse2.compulsivity
                }
            }
        }
        
        return visibleData
    }  
    
//    var chartData: [Relapse] {
//        //visibleData
//        let visibleData = data.filter { relapse in
//            relapse.date > (lens == .previous ? scale.previousDate : scale.startDate)
//        }
//        if lens.isGraded {
//            return visibleData.sorted { relapse1, relapse2 in
//                if lens == .intensity {
//                    relapse1.intensity > relapse2.intensity
//                } else {
//                    relapse1.compulsivity > relapse2.compulsivity
//                }
//            }
//        }
//        
//        return visibleData
//    }
    
    var body: some View {
        Group {
            if gradedData.count != 0 {
                Chart {
                    ForEach(gradedData) { relapse in
                        if lens == .previous {
                            BarMark(
                                x: .value("Day",
                                          scale.containsDate(relapse.date) ? relapse.date : relapse.date.addingTimeInterval(scale.timeInterval),
                                          unit: scale.calendarUnit(for: lens)),
                                y: .value("Count", 1)
                            )
                            .foregroundStyle(by: .value(
                                "Unit",
                                scale.containsDate(relapse.date) ? "Current" : "Previous"
                            ))
                            .position(by: .value("unit", scale.containsDate(relapse.date) ? "Current" : "Previous"))
                        } else {
                            BarMark(
                                x: .value("Day",
                                          scale.containsDate(relapse.date) ? relapse.date : relapse.date.addingTimeInterval(scale.timeInterval),
                                          unit: scale.calendarUnit(for: lens)),
                                y: .value("Count", 1)
                            )
                            .foregroundStyle(
                                lens.isGraded ? lens.color.opacity(Double(
                                    lens == .intensity ? relapse.intensity : relapse.compulsivity
                                ) / 10) : ChartLens.none.color
                            )
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
                                AnnotationView(data: gradedData,
                                               scale: scale,
                                               lens: lens,
                                               date: rawSelectedDate)
                            }
                        }
                    }
                }
                .chartXAxis {
                    if scale == ChartScale.week {
                        AxisMarks(values: .automatic(desiredCount: scale.domain)) { value in
                            AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                            AxisGridLine()
                            AxisTick()
                        }
                    } else {
                        AxisMarks()
                    }
                }
                .chartXSelection(value: $rawSelectedDate)
                .chartXScale(domain: [scale.startDate, Date.now])
                .chartForegroundStyleScale([
                    "Current": ChartLens.none.color,
                    "Previous": ChartLens.previous.color
                ])
                .chartLegend(lens == .previous ? .visible : .hidden)
                
                
                
            } else {
                ContentUnavailableView("Relapse Free", systemImage: "chart.line.uptrend.xyaxis", description: Text("What made \(scale == ChartScale.threeMonth ? "these" : "this") \(scale.rawValue.lowercased()) a success?"))
            }
        }
        .frame(height: chartHeight)
    }
}


struct AnnotationView: View {
    let data: [Relapse]
    let scale: ChartScale
    let lens: ChartLens
    let date: Date
    var previousDate: Date {
        date.addingTimeInterval(-scale.timeInterval)
    }
    var count: Int {
        data.reduce(0) { sum, relapse in
            sum + (relapse.date.isSame(as: date, unit: scale.calendarUnit(for: lens)) ? 1 : 0)
        }
    }
    var previousCount: Int {
        data.reduce(0) { sum, relapse in
            sum + (relapse.date.isSame(as: previousDate, unit: scale.calendarUnit(for: lens)) ? 1 : 0)
        }
    }
    
    var body: some View {
        VStack {
            Text(scale.formatDate(date, for: lens))
            .bold()
            if lens == .previous {
                HStack (spacing: 5) {
                    Group {
                        Text(String(count))
                            .foregroundStyle(ChartLens.none.color)
                            .font(.system(size: 25))
                            .bold()
                        Text(scale.subtitle(date: date, for: lens))
                            .font(.system(size: 15))
                        Spacer()
                        Text(String(previousCount))
                            .foregroundStyle(ChartLens.none.color.opacity(0.7))
                            .font(.system(size: 25))
                            .bold()
                        Text(scale.subtitle(date: previousDate, for: lens))
                            .font(.system(size: 15))
                    }
                }
            } else {
                Text("\(count) Relapse\(count == 1 ? "" : "s")")
            }
        }
        .padding()
        .background(.debugGray6)
        .clipShape(.rect(cornerSize: CGSize(width: 15, height: 15)))
    }
}

//#Preview("Chart") {
//    ChartView(rawSelectedDate: .constant(nil),
//              data: TestData.spreadsheet,
//              scale: ChartScale.week,
//              lens: ChartLens.previous)
//}

#Preview("Annotation") {
    AnnotationView(data: TestData.spreadsheet,
                   scale: ChartScale.week,
                   lens: ChartLens.previous,
                   date: Date.now)
}

