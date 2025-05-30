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
    let chartHeight: CGFloat = 250
    
    var chartData: [Relapse] {
        let chartData = data.filter { relapse in
            relapse.date > scale.startDate
        }
        
        if lens.isGraded {
            return chartData.sorted {
                if lens == .intensity {
                    $0.intensity > $1.intensity
                } else {
                    $0.compulsivity > $1.compulsivity
                }
            }
        }
        
        return chartData
    }
    
    private func maxByBucket(_ bucketKeyPath: KeyPath<Date, Date>) -> Int {
        max(Dictionary(grouping: chartData, by: { $0.date[keyPath: bucketKeyPath] })
            .map { (date, relapses) in relapses.count }.max() ?? 0, 2)
    }
    
    var body: some View {
        Group {
            if chartData.count != 0 {
                ChartWrapperView(
                    rawSelectedDate: $rawSelectedDate,
                    data: chartData,
                    scale: scale,
                    lens: lens
                )
                .if(scale == .year) {
                    $0.chartXAxis {
                        AxisMarks(values: .automatic) { value in
                            if let date = value.as(Date.self), date.endOfMonth != Date.now.endOfMonth {
                                AxisValueLabel()
                            } else {
                                AxisValueLabel("Now")
                            }
                            AxisGridLine()
                            AxisTick()
                        }
                    }
                }
                .if(scale == .month) {
                    $0.chartXAxis {
                        AxisMarks(values: AxisMarkValues.stride(by: .day, count: 7)) { value in
                            if let date = value.as(Date.self) {
                                Date.now.weekOfYear - date.weekOfYear == 0 ?
                                AxisValueLabel("This Week")
                                : Date.now.weekOfYear - date.weekOfYear == 1 ?
                                AxisValueLabel("Last Week")
                                :
                                AxisValueLabel(date.formatted(.dateTime.month(.abbreviated).day()))
                            }
                            AxisGridLine()
                            AxisTick()
                        }
                    }
                    .chartYScale(domain: [0, maxByBucket(\.endOfWeek)])
                }
                .if(scale == ChartScale.week) {
                    $0.chartXAxis {
                        AxisMarks(values: AxisMarkValues.stride(by: .day)) { value in
                            if let date = value.as(Date.self) {
                                Date.now.isSame(.day, as: date) ?
                                AxisValueLabel("Today")
                                :
                                AxisValueLabel(date.formatted(.dateTime.weekday(.abbreviated)))
                            }
                            AxisGridLine()
                            AxisTick()
                        }
                    }
                    .chartXScale(domain: [scale.startDate.endOfDay, Date.now.endOfDay.advanced(by: 1)])
                    .chartYScale(domain: [0, maxByBucket(\.endOfDay)])
                }
                .chartXSelection(value: $rawSelectedDate)
                .chartGesture { proxy in
                    DragGesture(minimumDistance: 0)
                        .onChanged {
                            if let date = proxy.value(atX: $0.location.x, as: Date.self) {
                                let chartDomain = proxy.xDomain(dataType: Date.self)
                                if (chartDomain.first!...chartDomain.last!).contains(date) {
                                    proxy.selectXValue(at: $0.location.x)
                                    return
                                }
                            }
                            rawSelectedDate = nil
                        }
                        .onEnded { _ in rawSelectedDate = nil }
                }
                
            } else {
                ContentUnavailableView("Relapse Free", systemImage: "chart.line.uptrend.xyaxis", description: Text("What made \(scale == ChartScale.threeMonth ? "these" : "this") \(scale.rawValue.lowercased()) a success?"))
            }
        }
#if !os(macOS)
        .frame(height: chartHeight)
#endif
    }
}

struct ChartWrapperView: View {
    @Binding var rawSelectedDate: Date?
    let data: [Relapse]
    let scale: ChartScale
    let lens: ChartLens
    
    var dataWithDummies: [Relapse] {
        var mutableData = data
        for date in stride(from: scale.startDate, to: Date.now, by: 24*60*60) {
            mutableData.append(Relapse(date: date, dummy: true))
        }
        return mutableData
    }
    
    var chartTitle: String {
        if lens == .none {
            return switch scale {
            case .week:
                "\(data.count) Relapse\(data.count != 1 ? "s" : "") in the Last Week"
            case .month:
                "Weekly Relapses (Rolling Month)"
            case .threeMonth:
                "Relapses from \(Date.monthName(scale.startDate.month)) to \(Date.monthName(Date.now.month))"
            case .year:
                "Relapses the Last 12 Months"
            }
        } else if lens == .intensity {
            if scale == .threeMonth {
                return "Relapse Intensity these \(scale.rawValue)"
            } else {
                return "Relapse Intensity this \(scale.rawValue)"
            }
        } else { //lens == .compulsion {
            if scale == .threeMonth {
                return "Urge Strength these \(scale.rawValue)"
            } else {
                return "Urge Strength this \(scale.rawValue)"
            }
        }
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            Text(chartTitle)
                .font(.headline)
                .opacity(scale.containsDate(rawSelectedDate) ? 0.0 : 1.0)
                .padding(.bottom, 5)
            GeometryReader { geometry in
                VStack (alignment: .center, spacing: 0) {
                    Chart {
                        ForEach(dataWithDummies) { relapse in
                            BarMark(
                                x: .value("Day", relapse.date, unit: scale.calendarUnit),
                                y: .value("Count", relapse.dummy ? 0 : 1)
                            )
                            .foregroundStyle(
                                lens.isGraded ? lens.color.opacity(Double(
                                    lens == .intensity ? relapse.intensity : relapse.compulsivity
                                ) / 10) : ChartLens.none.color
                            )
                        }
                        
                        if let rawSelectedDate, scale.containsDate(rawSelectedDate) {
                            RuleMark(
                                x: .value("Selected", rawSelectedDate, unit: scale.calendarUnit)
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
                    
                    if lens.isGraded {
                        Legend(lens: lens, segmentWidth: geometry.size.width / 12)
                    }
                }
            }
        }
    }
}

#Preview("Chart") {
    ChartView(rawSelectedDate: .constant(nil),
              data: SampleData.relapses,
              scale: ChartScale.month,
              lens: ChartLens.intensity)
}

#Preview("Annotation") {
    AnnotationView(data: SampleData.relapses,
                   scale: ChartScale.month,
                   lens: ChartLens.intensity,
                   date: Date.now)
}
