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
    var chartHeight: CGFloat = 280
    @ScaledMetric(relativeTo: .body) private var infoBarHeight: CGFloat = 32
    
    var chartData: [Relapse] {
        let start = lens == .compare ? scale.previousDate(scale.startDate) : scale.startDate
        let end = scale.endDate
        let chartData = data.filter { $0.date >= start && $0.date < end }
        
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
    
    private func tallestBar(in relapses: [Relapse]) -> Int {
        let calendar = Calendar.current
        let buckets = Dictionary(grouping: relapses) {
            calendar.dateInterval(of: scale.calendarUnit, for: $0.date)?.start ?? $0.date
        }
        return buckets.values.map(\.count).max() ?? 0
    }

    // MARK: body
    var body: some View {
        let relapses = chartData
        let showsChart = !relapses.isEmpty || scale == .week

        VStack(spacing: 0) {
            chartRegion(relapses: relapses, showsChart: showsChart)
#if !os(macOS)
                .frame(height: chartHeight)
#endif
            infoBar(relapses: relapses, showsChart: showsChart)
        }
    }

    private func chartRegion(relapses: [Relapse], showsChart: Bool) -> some View {
        Group {
            if showsChart {
                let peak = tallestBar(in: relapses)
                let minimumYMaximum = scale == .week ? 2.0 : 0.0
                let yMaximum = max(minimumYMaximum, Double(peak) / 0.9)
                let tickStep = (max(peak, 1) - 1) / 4 + 1
                let ticks = Array(stride(from: 0, through: Int(yMaximum), by: tickStep))
                ChartWrapperView(
                    rawSelectedDate: $rawSelectedDate,
                    data: relapses,
                    scale: scale,
                    lens: lens
                )
                // MARK: axes
                .chartYScale(domain: 0.0...yMaximum)
                .chartYAxis {
                    AxisMarks(values: ticks)
                }
                .if(scale == .month) {
                    $0.chartXAxis {
                        AxisMarks(values: AxisMarkValues.stride(by: .day, count: 7)) { value in
                            if let date = value.as(Date.self) {
                                if scale.isSameBucket(date, as: .now) {
                                    AxisValueLabel("This Week")
                                } else if let lastWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: .now),
                                          scale.isSameBucket(date, as: lastWeek) {
                                    AxisValueLabel("Last Week")
                                } else {
                                    AxisValueLabel(date.formatted(.dateTime.month(.abbreviated).day()))
                                }
                            }
                            AxisGridLine()
                            AxisTick()
                        }
                    }
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
                    .chartXScale(domain: scale.startDate...scale.endDate)
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
    }

    private func infoBar(relapses: [Relapse], showsChart: Bool) -> some View {
        GeometryReader { geometry in
            if showsChart {
                if lens.isGraded {
                    Legend(lens: lens, segmentWidth: geometry.size.width / 12)
                        .frame(maxWidth: .infinity)
                } else if lens == .compare {
                    HStack {
                        Text("Totals:")
                        Text("\(relapses.count { $0.date >= scale.startDate })")
                            .padding(2)
                            .padding(.horizontal, 5)
                            .foregroundStyle(.white)
                            .background {
                                Capsule()
                                    .fill(.accent)
                            }
                        Text("\(relapses.count { $0.date < scale.startDate })")
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
        .frame(height: infoBarHeight)
    }
}

// MARK: - CHARTWRAPPERVIEW
struct ChartWrapperView: View {
    @Binding var rawSelectedDate: Date?
    let data: [Relapse]
    let scale: ChartScale
    let lens: ChartLens
    
    private var bucketDates: [Date] {
        let calendar = Calendar.current
        let end = scale.endDate
        var date = scale.startDate
        var dates: [Date] = []
        while date < end {
            dates.append(date)
            date = calendar.date(byAdding: scale.calendarUnit, value: 1, to: date)!
        }
        return dates
    }

    // Keep empty buckets visible in the standard chart.
    private var dataWithDummies: [Relapse] {
        data + bucketDates.map { Relapse(date: $0, dummy: true) }
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
    private func barMarks() -> some ChartContent {
        ForEach(dataWithDummies) { relapse in
            BarMark(
                x: .value("Date", relapse.date, unit: scale.calendarUnit),
                y: .value("Count", relapse.dummy ? 0 : 1)
            )
            .foregroundStyle(barMarkColor(relapse: relapse))
        }
    }

    private func comparisonMarks() -> some ChartContent {
        let calendar = Calendar.current
        return ForEach(bucketDates, id: \.self) { date in
            let bucket = calendar.dateInterval(of: scale.calendarUnit, for: date)!
            let priorDate = scale.previousDate(date)
            let latestCount = data.count { scale.isSameBucket($0.date, as: date) }
            let priorCount = data.count { scale.isSameBucket($0.date, as: priorDate) }

            // Each pair occupies the middle 80% of its calendar bucket.
            RectangleMark(
                xStart: .value("Start", bucket.start.addingTimeInterval(bucket.duration * 0.10)),
                xEnd: .value("End", bucket.start.addingTimeInterval(bucket.duration * 0.47)),
                yStart: .value("Baseline", 0),
                yEnd: .value("Latest", latestCount)
            )
            .foregroundStyle(Color.accentColor)

            RectangleMark(
                xStart: .value("Start", bucket.start.addingTimeInterval(bucket.duration * 0.53)),
                xEnd: .value("End", bucket.start.addingTimeInterval(bucket.duration * 0.90)),
                yStart: .value("Baseline", 0),
                yEnd: .value("Prior", priorCount)
            )
            .foregroundStyle(Color.accentColor.opacity(0.2))
        }
    }

    private func barMarkColor(relapse: Relapse) -> Color {
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

                if lens == .compare {
                    comparisonMarks()
                } else {
                    barMarks()
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

            .if(lens == .compare && scale != .week) {
                $0.chartXScale(domain: scale.startDate...scale.endDate)
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
