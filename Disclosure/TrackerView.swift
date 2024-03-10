//
//  TrackerView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/3/24.
//

import SwiftUI
import SwiftData

fileprivate enum Segue {
    case loggerView
    case logView
}

struct TrackerView: View {
    let data: [Relapse]
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack (path: $path) {
            InsideTrackerView(data: data, path: $path)
                .navigationTitle("Tracker")
                .navigationDestination(for: Segue.self) {
                    switch $0 {
                    case .logView:
                        LogView(path: $path, relapses: data)
                    case .loggerView:
                        LoggerView(path: $path)
                    }
                }
                .navigationDestination(for: Relapse.self) {
                    DisclosureView(path: $path, relapse: $0, fromLogger: false)
                }
        }
    }
}

struct InsideTrackerView: View {
    let data: [Relapse]
    @State private var selectedChartScale = ChartScale.week
    @State private var selectedChartLens = ChartLens.none
    @State private var rawSelectedDate: Date? = nil
    @Binding var path: NavigationPath
    private var lensPickerWidth: CGFloat {
        switch selectedChartLens {
        case .none:
            108.0
        case .compulsion:
            155.0
        default:
            130.0
        }
    }
    private var averageStreak: Int {
        //three month average streak
        let rollingThreeMonthCount = data.filter {
            $0.date >= Date.now.addingTimeInterval(ChartScale.month.timeInterval * -3)
        }.count
        
        if rollingThreeMonthCount == 0 {
            return 0
        } else {
            // either rolling or the furthest the data goes
            return min(ChartScale.month.domain * 3, Int(data.last!.date.timeIntervalSinceNow / -89600)) / rollingThreeMonthCount
        }
    }
    private var currentStreak: Int {
        return Int((data.max(by: { $0.date < $1.date })?.date.timeIntervalSinceNow ?? 0) / (-24*60*60))
    }
    
    var body: some View {
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
            .opacity(rawSelectedDate == nil ? 1.0 : 0.0) // to remove disappear for graded (|| selectedChartLens.isGraded)
            
            ChartView(rawSelectedDate: rawSelectedDate, data: data, scale: selectedChartScale, lens: selectedChartLens).padding()
            HStack {
                Picker(selection: $selectedChartLens) {
                    ForEach(ChartLens.allCases) { lens in
                        Text(lens.rawValue)
                    }
                } label: {
                    Text("View")
                }
                .pickerStyle(.navigationLink)
                .padding(.leading)
                .frame(maxWidth: lensPickerWidth)
                
                Spacer()
                
                Button {
                    path.append(Segue.logView)
                } label: {
                    Label("More", systemImage: "ellipsis.circle")
                }
                .padding(.trailing)
            }
            
            Spacer()
            
            HStack {
                MetricView(count: averageStreak,
                           name: "Average Streak")
                .padding(.leading, 40)
                Spacer()
                MetricView(count: currentStreak, name: "Days Sober")
                    .padding(.trailing, 40)
            }
            
            Spacer()
            
            Button {
                path.append(Segue.loggerView)
            } label: {
                Label("Log Relapse", systemImage: "arrow.counterclockwise")
            }
            .buttonStyle(.borderedProminent)
            .padding()
            
        }
    }
}

struct MetricView: View {
    let count: Int
    let name: String
    
    var body: some View {
        VStack {
            HStack {
                Text(String(count))
                    .font(.system(size: 70))
                Text("Days")
            }
            Text(name)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    TrackerView(data: TestData.spreadsheet)
}


