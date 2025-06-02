//
//  ChartView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/27/24.
//

import SwiftUI
import Charts

// MARK: - CHARTVIEW
struct ChartView: View {
    @Binding var rawSelectedDate: Date?
    let data: [Relapse]
    let scale: ChartScale
    let lens: ChartLens
    let chartHeight: CGFloat = 250
    
    var chartData: [Relapse] {
        let chartData = data.filter { relapse in
            relapse.date > (lens == .compare ? scale.previousDate(scale.startDate) : scale.startDate)
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
    
    // MARK: body
    var body: some View {
        Group {
            if chartData.count != 0 || scale == .week {
                ChartWrapperView(
                    rawSelectedDate: $rawSelectedDate,
                    data: chartData,
                    scale: scale,
                    lens: lens
                )
                // MARK: axes
                .if(scale == .threeMonth || scale == .year) {
                    $0.chartYScale(domain: [0, maxByBucket(\.endOfMonth)])
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
                    .chartXScale(domain: [Date.now.startOfWeek, Date.now.endOfWeek.advanced(by: 1)])
                    .chartYScale(domain: [0, maxByBucket(\.endOfDay)])
                }
                .chartXSelection(value: $rawSelectedDate)
                // MARK: chartGesture
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

// MARK: - CHARTWRAPPERVIEW
struct ChartWrapperView: View {
    @Binding var rawSelectedDate: Date?
    let data: [Relapse]
    let scale: ChartScale
    let lens: ChartLens
    
    //dummies make certain every day displays even if empty
    var dataWithDummies: [Relapse] {
        var mutableData = data
        for date in stride(from: scale.startDate, to: Date.now, by: 24*60*60) {
            mutableData.append(Relapse(date: date, dummy: true))
        }
        return mutableData
    }
    
    // MARK: chartTitle
    var chartTitle: String {
        let demonstrative = scale == .threeMonth ? "these" : "this"
        
        if lens == .none {
            return switch scale {
            case .week:
                data.count == 0 ? "No Relapses to Show" : "\(data.count) Relapse\(data.count != 1 ? "s" : "") this Week"
            case .month:
                "Relapses over the Recent Month"
            case .threeMonth:
                "Relapses from \(Date.monthName(scale.startDate.month)) to \(Date.monthName(Date.now.month))"
            case .year:
                "Relapses the Last 12 Months"
            }
        }
        
        if lens == .intensity {
            return "Relapse Intensity \(demonstrative) \(scale.rawValue)"
        }
        
        if lens == .compulsion {
            return "Urge Strength \(demonstrative) \(scale.rawValue)"
        }
        
        if scale == .threeMonth {
            return "Latest Months vs Prior Months"
        }
        
        return "T\(demonstrative.dropFirst()) \(scale.rawValue) vs Last \(scale.rawValue)"
    }
    
    // MARK: barMarks
    private func barMarks(_ width: CGFloat) -> some ChartContent {
        let markWidth = switch scale {
        case .week:
            17.0
        case .month:
            20.0
        case .threeMonth:
            45.0
        case .year:
            10.0
        }
        
        let bucketWidth = switch scale {
        case .week:
            22.0
        case .month:
            26.0
        case .threeMonth:
            55.0
        case .year:
            6.0
        }
        
        return ForEach(dataWithDummies) { relapse in
            BarMark(
                x: .value("Day", relapse.date < scale.startDate ? scale.nextDate(relapse.date) : relapse.date, unit: scale.calendarUnit),
                y: .value("Count", relapse.dummy ? 0 : 1),
                width: lens == .compare ? .fixed(markWidth) : .automatic
            )
            .foregroundStyle(barMarkColor(relapse: relapse))
            .if(lens == .compare) {
                $0.position(by: .value("Period", Int(relapse.date < scale.startDate)), span: MarkDimension(floatLiteral: bucketWidth))
            }
        }
    }
    
    private func barMarkColor(relapse: Relapse) -> Color {
        if relapse.date < scale.startDate {
            return .accent.opacity(0.2)
        }

        if lens.isGraded {
            return lens.color.opacity(Double(
                lens == .intensity ? relapse.intensity : relapse.compulsivity
            ) / 10)
        }

        return ChartLens.none.color
    }
    
    // MARK: body
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                Text(chartTitle)
                    .font(.headline)
                    .opacity(scale.containsDate(rawSelectedDate) ? 0.0 : 1.0)
                    .padding(.bottom, 5)
            }
            
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 0) {
                    Chart {
                        if scale == .week {
                            RectangleMark(
                                xStart: .value("Day", Date.now.endOfDay),
                                xEnd: .value("Day", Date.now.endOfWeek),
                                yStart: nil,
                                yEnd: nil
                            )
                            .foregroundStyle(.gray.opacity(0.125))
                        }
                        
                        barMarks(geometry.size.width)
                        
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
                    } else if lens == .compare {
                        HStack {
                            Text("Totals:")
                            Text("\(data.count { $0.date >= scale.startDate })")
                                .padding(2)
                                .padding(.horizontal, 5)
                                .foregroundStyle(.white)
                                .background {
                                    Capsule()
                                        .fill(.accent)
                                }
                            Text("\(data.count { $0.date < scale.startDate })")
                                .padding(2)
                                .padding(.horizontal, 5)
                                .background {
                                    Capsule()
                                        .fill(.accent.opacity(0.2))
                                }
                            
                            Spacer()
                            
                            Text("Latest")
                                .padding(2)
                                .padding(.horizontal, 5)
                                .foregroundStyle(.white)
                                .background {
                                    Capsule()
                                        .fill(.accent)
                                }
                                .padding(.trailing, 2)
                            Text("Prior")
                                .padding(2)
                                .padding(.horizontal, 5)
                                .background {
                                    Capsule()
                                        .fill(.accent.opacity(0.2))
                                }
                                .padding(.trailing)
                        }
                        .font(.caption)
                        .padding(.top, 5)
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
