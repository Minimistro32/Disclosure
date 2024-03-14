//
//  ChartView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/27/24.
//

//TODO: FIX incorrect annotations
//TODO: FIX the week labels on the month view to be rolling as well
//TODO: FIX jank on date on left/right side on normal week view. Pretty sure it is caused by inexact day starts and stops. Needs to be 0hrs/mins
//TODO: FIX labels on three months .previous view
//TODO: Add title


import SwiftUI
import Charts

struct ChartView: View {
    
    @State var rawSelectedDate: Date?
    let data: [Relapse]
    let scale: ChartScale
    let lens: ChartLens
    let chartHeight: CGFloat = 250
    
    var chartData: [Relapse] {
        //visibleData
        var visibleData = data.filter { relapse in
            relapse.date > (lens == .previous ? scale.previousDate : scale.startDate)
        }
        if lens.isGraded {
            return visibleData.sorted {
                if lens == .intensity {
                    $0.intensity > $1.intensity
                } else {
                    $0.compulsivity > $1.compulsivity
                }
            }
        }
        if lens == .previous {
            for date in stride(from: scale.previousDate, to: scale.startDate, by: 24*60*60) {
                if !(scale == .month && date.formatted(.dateTime.week(.weekOfMonth)) == "6") {
                    visibleData.append(Relapse(date: date, dummy: true))
                }
            }
            
            return visibleData.sorted {
                if scale.containsDate($0.date) != scale.containsDate($1.date) && !$0.dummy{
                    return scale.containsDate($0.date)
                } else {
                    return $0.date < $1.date
                }
            }
        }
        
        return visibleData
    }
    
    var body: some View {
        Group {
            if chartData.count != 0 {
                InsideChartView(
                    rawSelectedDate: $rawSelectedDate,
                    data: chartData,
                    scale: scale,
                    lens: lens
                )
                .if(scale == ChartScale.week && lens != .previous) {
                    $0.chartXAxis {
                        AxisMarks(values: .automatic(desiredCount: scale.domain)) { value in
                            AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                            AxisGridLine()
                            AxisTick()
                        }
                    }
                    .chartXScale(domain: [scale.startDate, Date.now])
                }
                //                .if(lens == .previous) {
                //                    $0.chartXAxis {
                //                        AxisMarks(values: AxisMarkValues())
                //                    }
                //                }
                .if(lens == .previous) {
                    $0.chartForegroundStyleScale([
                        "Current": ChartLens.none.color,
                        "Previous": ChartLens.previous.color
                    ])
                    .chartLegend()
                }
                .chartXSelection(value: $rawSelectedDate)
                
            } else {
                ContentUnavailableView("Relapse Free", systemImage: "chart.line.uptrend.xyaxis", description: Text("What made \(scale == ChartScale.threeMonth ? "these" : "this") \(scale.rawValue.lowercased()) a success?"))
            }
        }
#if !os(macOS)
        .frame(height: chartHeight)
#endif
    }
}

struct InsideChartView: View {
    @Binding var rawSelectedDate: Date?
    let data: [Relapse]
    let scale: ChartScale
    let lens: ChartLens
    
    var body: some View {
        Chart {
            if lens != .previous {
                ForEach(data) { relapse in
                    BarMark(
                        x: .value("Day", relapse.date, unit: scale.calendarUnit()),
                        y: .value("Count", 1)
                    )
                    .foregroundStyle(
                        lens.isGraded ? lens.color.opacity(Double(
                            lens == .intensity ? relapse.intensity : relapse.compulsivity
                        ) / 10) : ChartLens.none.color
                    )
                }
            } else {
                ForEach(data) { relapse in
                    BarMark(
                        x: .value("Unit", scale.formatDate(relapse.date)),
                        y: .value("Count", relapse.dummy ? 0 : 1)
                    )
                    .foregroundStyle(by: .value(
                        "Unit",
                        scale.containsDate(relapse.date) ? "Current" : "Previous"
                    ))
                    .position(by: .value("Unit", scale.containsDate(relapse.date) ? "Current" : "Previous"))
                }
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
                    AnnotationView(data: data,
                                   scale: scale,
                                   lens: lens,
                                   date: rawSelectedDate)
                }
            }
        }
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
            sum + (relapse.date.isSame(as: date, unit: scale.calendarUnit()) ? 1 : 0)
        }
    }
    var previousCount: Int {
        data.reduce(0) { sum, relapse in
            sum + (relapse.date.isSame(as: previousDate, unit: scale.calendarUnit()) ? 1 : 0)
        }
    }
    
    var body: some View {
        VStack {
            Text(scale.formatAnnotationDate(date, for: lens))
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
#if os(macOS)
        .background(Color(hue: 1, saturation: 0, brightness: 0.82))
#else
        .background(.debugGray6)
#endif
        .clipShape(.rect(cornerSize: CGSize(width: 15, height: 15)))
    }
}

#Preview("Chart") {
    ChartView(rawSelectedDate: nil,
              data: TestData.spreadsheet,
              scale: ChartScale.week,
              lens: ChartLens.previous)
}

#Preview("Annotation") {
    AnnotationView(data: TestData.spreadsheet,
                   scale: ChartScale.week,
                   lens: ChartLens.previous,
                   date: Date.now)
}

//func previousXValue<X>(scale: ChartScale, relapse: Relapse) -> PlottableValue<X> {
//    return
//    }
//}
