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
            DashboardView(data: data, path: $path)
#if !os(macOS)
                .navigationTitle("Tracker")
                .toolbar {
                    Button {
                        path.segue(to: .loggerView)
                    } label: {
                        Label("Log Relapse", systemImage: "plus")
                    }
                }
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

struct DashboardView: View {
    let data: [Relapse]
    @State private var selectedChartScale = ChartScale.month
    @State private var selectedChartLens = ChartLens.none
    @State var rawSelectedDate: Date?
    @Binding var path: NavigationPath
    
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
    
    var reminderCount: Int {
        data.filter { $0.reminder }.count
    }
    
    @Environment(\.modelContext) private var context
    @Query private var _settings: [Settings]
    private var settings: Settings {
        var s = _settings.first
        if s == nil {
            s = Settings()
            context.insert(s!)
        }
        return s!
    }
    
    @ViewBuilder
    private var BadgeButton: some View {
        ZStack {
            LinkButton(title: "More", systemImage: "ellipsis.circle") {
                path.segue(to: .logView)
            }
            
            if reminderCount > 0 && settings.analyzeBadges {
                Image(systemName: "\(reminderCount > 50 ? 50 : reminderCount).circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.accent)
                    .background(.white, in: .circle.inset(by: 3), fillStyle: FillStyle(eoFill: false, antialiased: false))
                    .offset(x: 40, y: -13)
            }
        }
        .padding(.trailing, 15 + (CGFloat(reminderCount) > 0 ? 5 : 0))
    }
    
#if os(macOS)
    var body: some View { //macOS
        VStack {
            HStack {
                Picker(selection: $selectedChartScale) {
                    ForEach(ChartScale.allCases) { interval in
                        Text(interval.rawValue)
                    }
                } label: {
                    Text("Time Interval for Chart")
                }
                .pickerStyle(.segmented)
                .padding()
                .opacity(rawSelectedDate == nil ? 1.0 : 0.0)
             
                LinkButton(title: "Log Relapse", systemImage: "arrow.counterclockwise") {
                    path.segue(to: .loggerView)
                }
                BadgeButton(path: $path, count: reminderCount)
            }
            
            HStack(alignment: .bottom) {
                VStack (alignment: .center) {
                    Spacer()
                    StreakView(average: averageStreak, current: currentStreak)
                    Spacer()
                    
                    Picker(selection: $selectedChartLens) {
                        ForEach(ChartLens.allCases) { lens in
                            Text(lens.rawValue)
                        }
                    } label: {
                        Text("View")
                    }
                    .padding(.init(top: 7, leading: 10, bottom: 7, trailing: 10))
                    .tint(selectedChartLens.isGraded ? selectedChartLens.color : .accent)
                    .background(.gray.opacity(0.2), in: .buttonBorder, fillStyle: FillStyle(eoFill: false, antialiased: false))
                    .padding(.leading, 15)
                    .pickerStyle(.radioGroup)
                    .padding(.bottom, 30)
                    Spacer()
                }
                
                ChartView(rawSelectedDate: rawSelectedDate, data: data, scale: selectedChartScale, lens: selectedChartLens).padding()
            }
            
        }
    }
#else
    var body: some View { //iOS
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
            .opacity(rawSelectedDate == nil ? 1.0 : 0.0)
            
            ChartView(rawSelectedDate: $rawSelectedDate, data: data, scale: selectedChartScale, lens: selectedChartLens).padding(.init(top: 0, leading: 15, bottom: 10, trailing: 10))
            
            HStack(alignment: .bottom) {
                LabeledPicker(title: "View", values: ChartLens.allCases, selection: $selectedChartLens, toString: { $0.rawValue })
                .tint(selectedChartLens.isGraded ? selectedChartLens.color : .accent)
                .background(.gray.opacity(0.2), in: .buttonBorder, fillStyle: FillStyle(eoFill: false, antialiased: false))
                .padding(.leading, 15)
                
                Spacer()
                
                BadgeButton
            }
            
            Spacer()
            
            HStack {
                StreakView(average: averageStreak, current: currentStreak)
            }
            
            Spacer()
            
            Button {
                path.segue(to: .loggerView)
            } label: {
                Label("Log Relapse", systemImage: "arrow.counterclockwise")
                    .frame(width: 240)
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
    }
#endif
}

#Preview {
    TrackerView(data: TestData.spreadsheet)
}


