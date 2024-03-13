//
//  TrackerView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/3/24.
//

import SwiftUI
import SwiftData

struct TrackerView: View {
    let data: [Relapse]
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack (path: $path) {
            InsideTrackerView(data: data, path: $path)
#if !os(macOS)
                .navigationTitle("Tracker")
#endif
                .navigationDestination(for: Segue.self) {
                    switch $0.destination {
                    case .logView:
                        LogView(path: $path, relapses: data)
                    case .loggerView:
                        if let relapse = $0.payload as? Relapse {
                            LoggerView(path: $path, relapse: relapse, relapseReminderProxy: relapse.reminder)
                        } else {
                            LoggerView(path: $path)
                        }
                    case .disclosureView:
                        DisclosureView(path: $path, relapse: $0.payload as! Relapse)
                    default:
                        ErrorView(description: "Unaccounted Segue To \($0.destination) ")
                    }
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
            108.0 + 10
        case .compulsion:
            155.0 + 10
        default:
            130.0 + 10
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
        Int((data.max(by: { $0.date < $1.date })?.date.timeIntervalSinceNow ?? 0) / (-24*60*60))
    }
    
    private var reminderCount: Int {
        data.filter { $0.reminder }.count
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
#if os(macOS)
                .pickerStyle(.radioGroup)
#else
                .pickerStyle(.navigationLink)
                .frame(maxWidth: lensPickerWidth)
#endif
                .padding(.init(top: 7, leading: 10, bottom: 7, trailing: 10))
                .tint(selectedChartLens.isGraded ? selectedChartLens.color : .accent)
                .background(.gray.opacity(0.2), in: .buttonBorder, fillStyle: FillStyle(eoFill: false, antialiased: false))
                .padding(.leading, 15)
                
                Spacer()
                
                ZStack {
                    LinkButton(title: "More", systemImage: "ellipsis.circle") {
                        path.append(Segue(to: .logView))
                    }
                    
                    if reminderCount > 0 {
                        Image(systemName: "\(reminderCount > 50 ? 50 : reminderCount).circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.accent)
                            .background(.white, in: .circle.inset(by: 3), fillStyle: FillStyle(eoFill: false, antialiased: false))
                            .offset(x: 40, y: -13)
                    }
                }
                .padding(.trailing, 15 + (reminderCount > 0 ? 5 : 0))
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
                path.append(Segue(to: .loggerView))
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


