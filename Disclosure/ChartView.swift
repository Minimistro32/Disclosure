//
//  ChartView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/27/24.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    @Binding var rawSelectedDate: Date?
    let data: [Relapse]
    let scale: ChartScale
    let lens: ChartLens
    
    var visibleData: [Relapse] {
        let filtered = data.filter { relapse in
            relapse.date >= Date.now.addingTimeInterval(-1 * scale.timeInterval)
        }
        if lens.isGraded {
            return filtered.sorted { relapse1, relapse2 in
                if lens == .intensity {
                    relapse1.intensity > relapse2.intensity
                } else {
                    relapse1.compulsivity > relapse2.compulsivity
                }
            }
        } else {
            return filtered
        }
    }
    
    let chartHeight: CGFloat = 250
    
    var body: some View {
        // TITLE CODE
        //            if visibleData.count != 0 {
        //                Text("\(visibleData.count) Relapses")
        //                    .font(.headline)
        //                    .offset(y: chartHeight / -2 - 20)
        //                    .opacity(rawSelectedDate == nil ? 1.0 : 0.0)
        //            }
        Group {
            if visibleData.count != 0 {
                Chart {
                    ForEach(visibleData) { relapse in
                        BarMark(
                            x: .value("Day", relapse.date, unit: scale.calendarComponent),
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
                            AnnotationView(date: rawSelectedDate,
                                           data: visibleData,
                                           scale: scale)
                        }.opacity(1.0)
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
                
                
                
            } else {
                ContentUnavailableView("Relapse Free", systemImage: "chart.line.uptrend.xyaxis", description: Text("What made \(scale == ChartScale.threeMonth ? "these" : "this") \(scale.rawValue.lowercased()) a success?"))
            }
        }
        .frame(height: chartHeight)
    }
}


struct AnnotationView: View {
    let date: Date
    let data: [Relapse]
    let scale: ChartScale
    var count: Int {
        data.reduce(0) { sum, relapse in
            sum + (relapse.date.isSame(as: date, unit: scale.calendarComponent) ? 1 : 0)
        }
    }
    
    var dateString: String {
        switch scale {
        case ChartScale.week:
            date.formatted(.dateTime.weekday(.wide))
        case ChartScale.month:
            date.formatted(.dateTime.weekday(.wide).month().day())
        case ChartScale.threeMonth:
            date.formatted(.dateTime.month()) + ", Week " + date.formatted(.dateTime.week(.weekOfMonth))
            //            "Week " + date.formatted(.dateTime.week(.weekOfMonth)) + ", " + date.formatted(.dateTime.month())
        case ChartScale.year:
            date.formatted(.dateTime.month(.wide).year())
        }
    }
    //    var avgIntensity: Int? {
    //        if data.count > 0 {
    //            return data.reduce(0) { sum, relapse in
    //                sum + relapse.intensity
    //            } / data.count
    //        } else {
    //            return nil
    //        }
    //    }
    //    var avgCompulsivity: Int? {
    //        if data.count > 0 {
    //            return data.reduce(0) { sum, relapse in
    //                sum + relapse.compulsivity
    //            } / data.count
    //        } else {
    //            return nil
    //        }
    //    }
    
    var body: some View {
        VStack {
            Group {
                Text(dateString)
            }
            .bold()
            Text("\(count) Relapse\(count == 1 ? "" : "s")")
        }
        .padding()
        .background(.quaternary)
        .clipShape(.rect(cornerSize: CGSize(width: 15, height: 15)))
    }
}

#Preview("Chart") {
    ChartView(rawSelectedDate: .constant(nil),
              data: TestData.spreadsheet,
              scale: ChartScale.threeMonth,
              lens: ChartLens.none)
}

#Preview("Annotation") {
    AnnotationView(date: Date.now,
                   data: TestData.spreadsheet,
                   scale: ChartScale.threeMonth)
}
