//
//  ChartView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/27/24.
//

//TODO: Add title


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
    
    var weekBucketMax: Int {
        max(Dictionary(grouping: chartData, by: { $0.date.endOfDay })
            .map { (date, relapses) in relapses.count }.max() ?? 0, 2)
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
                    .chartXScale(domain: [scale.startDate.endOfDay!, Date.now.endOfDay!.advanced(by: 1)])
                    .chartYScale(domain: [0, weekBucketMax])
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

struct InsideChartView: View {
    @Binding var rawSelectedDate: Date?
    @State var legendDrag: CGPoint?
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
    
    private func legend(segmentWidth: CGFloat, cornerRadius: CGFloat = 10) -> some View {
        
        let category: String = Relapse.categoricalIntensity(for: Double(legendDrag?.x ?? 0) / segmentWidth)
        let annotationWidth: CGFloat = switch category {
                case "New Material":
                    120
                case "Nudity":
                    70
                case "Revealing Clothes":
                    160
                case "Masturbation":
                    130
                default:
                    0
            }
        
        var dragLegend: some Gesture {
            DragGesture(minimumDistance: 5)
                .onChanged { value in
                    if (0..<(segmentWidth * 10)).contains(value.location.x) {
                        legendDrag = value.location
                    } else {
                        legendDrag = nil
                    }
                }
                .onEnded { _ in legendDrag = nil }
        }
        
        
        func gradation(index: Int) -> some View {
            ZStack(alignment: .leading) {
                UnevenRoundedRectangle(cornerRadii: .init(topLeading: index == 0 ? cornerRadius : 0,
                                                          bottomLeading: index == 0 ? cornerRadius : 0,
                                                          bottomTrailing: index == 9 ? cornerRadius : 0,
                                                          topTrailing: index == 9 ? cornerRadius : 0),
                                       style: .continuous)
                .frame(width: segmentWidth, height: cornerRadius)
                .foregroundStyle(lens.color)
                .opacity(Double(index + 1) / 10)
                
                if lens == .intensity && [2,4,8].contains(index) {
                    Rectangle()
                        .fill(Color(UIColor.label).opacity(0.4))
                        .frame(width: 2, height: cornerRadius)
                }
            }
        }
        
        return HStack {
            Text("1").fontWeight(.ultraLight)
            HStack(spacing: 0) {
                ForEach(0..<10, id: \.self) { index in
                    gradation(index: index)
                }
            }
            .gesture(dragLegend)
            Text("10").fontWeight(.ultraLight)
        }
        .padding(.top, 5)
        .if(legendDrag != nil && lens == .intensity) {
            $0.overlay(alignment: .leading) {
                VStack(spacing: 0) {
                    Text(category)
                        .frame(width: annotationWidth, height: 40)
//                        .background(Color(hue: 1, saturation: 0, brightness: 0.82))
                        .background(.debugGray6)
                        .clipShape(.rect(cornerSize: CGSize(width: 15, height: 15)))
                    Rectangle()
                        .foregroundStyle(Color.gray.opacity(0.3))
                        .frame(width: 2, height: cornerRadius + 10)
                    
                }
                .offset(x: legendDrag!.x - (annotationWidth / 2) + 15, y: -22)
            }
        }
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            //TODO: finish titles
            Text("\(data.count) Relapses")
                .font(.headline)
                .opacity(rawSelectedDate == nil ? 1.0 : 0.0)
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
                        
                        if let rawSelectedDate {
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
                        legend(segmentWidth: geometry.size.width / 12)
                    }
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
    
    private var selectedData: [Relapse] {
        data.filter { $0.date.isSame(scale.calendarUnit, as: date) }
    }
    
    private var dateString: String {
        switch scale {
        case .week:
            date.formatted(.dateTime.month(.wide).day())
        case .month:            date.startOfWeek!.formatted(.dateTime.month().day()) + " - " + date.endOfWeek!.formatted(.dateTime.month().day())
        case .threeMonth:
            date.formatted(.dateTime.month(.wide))
        case .year:
            date.formatted(.dateTime.month(.wide).year())
        }
    }
    
    var average: Double {
        selectedData.reduce(0.0) { sum, relapse in
            sum + Double(lens == .intensity ? relapse.intensity : relapse.compulsivity)
        } / (selectedData.count == 0 ? 1.0 : Double(selectedData.count))
    }
    
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0 // Minimum number of fractional digits
        formatter.maximumFractionDigits = 1 // Maximum number of fractional digits
        return formatter
    }
    
    //    var intensityCounts: [String] {//Dictionary<String, [Relapse]> {
    //        Dictionary(grouping: selectedData, by: { $0.categoricalIntensity })
    //            .sorted(by: { Relapse.categoricalIntensity(for: $0.0) >  Relapse.categoricalIntensity(for: $1.0)})
    //            .compactMap { grouping in
    //                if grouping.value.count == 0 {
    //                    return nil
    //                } else {
    //                    return grouping.key + ": " + String(grouping.value.count)
    //                }
    //            }
    //    }
    
    var body: some View {
        VStack {
            Text(dateString)
                .bold()
            if lens == .none {
                Text("\(selectedData.count) Relapse\(selectedData.count == 1 ? "" : "s")")
            } else if average != 0 {
                Text(numberFormatter.string(from: average as NSNumber)! + " on Average")
            }
        }
        .padding()
#if os(macOS)
        .background(Color(hue: 1, saturation: 0, brightness: 0.82))
#else
                .background(.debugGray6)
//        .background(Color.gray.opacity(0.3))
#endif
        .clipShape(.rect(cornerSize: CGSize(width: 15, height: 15)))
    }
}

#Preview("Chart") {
    ChartView(rawSelectedDate: .constant(nil),
              data: TestData.spreadsheet,
              scale: ChartScale.month,
              lens: ChartLens.intensity)
}

#Preview("Annotation") {
    AnnotationView(data: TestData.spreadsheet,
                   scale: ChartScale.month,
                   lens: ChartLens.intensity,
                   date: Date.now)
}

//func previousXValue<X>(scale: ChartScale, relapse: Relapse) -> PlottableValue<X> {
//    return
//    }
//}
