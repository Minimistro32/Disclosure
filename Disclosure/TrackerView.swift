//
//  TrackerView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/3/24.
//

import SwiftUI
import Charts

struct TrackerView: View {
    
    //    let data = MockData.liveJanDayView
    //    let data = MockData.novemberDayView
    let data = MockData.octoberDayView
    
    @Binding var rawSelectedDate: Date?

    var selectedDate: Date? {
      guard let rawSelectedDate else { return nil }
      return data.first(where: {
        return $0.date == rawSelectedDate
      })?.date
    }
    
    var body: some View {
        ZStack {
            Chart {
                ForEach(data) { dayView in
                    BarMark(
                        x: .value("Day", dayView.date, unit: .day),
                        y: .value("Count", dayView.count)
                    )
                    .foregroundStyle(Color.red.opacity(Double(dayView.intensity) / 10))
                    
                }
                if let selectedDate {
                    RuleMark(
                        x: .value("Selected", selectedDate, unit: .day)
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
            .frame(height: 250) //180
            .chartYAxis {
                data.reduce(0) { $0 > $1.count ? $0 : $1.count } == 1 ? AxisMarks(values: [0, 1, 2]) : AxisMarks(values: .automatic)
                
            }
            .chartXSelection(value: $rawSelectedDate)
        }
    }
}

#Preview {
    TrackerView(rawSelectedDate: .constant(Date.from(year: 2023, month: 10, day: 6)))
}
