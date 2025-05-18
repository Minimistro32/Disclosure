//
//  Annotation.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/20/24.
//

import SwiftUI

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
        case .month:
            date.startOfWeek!.formatted(.dateTime.month().day()) + " - " + date.endOfWeek!.formatted(.dateTime.month().day())
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
