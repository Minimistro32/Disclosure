//
//  DisclosureWidgets.swift
//  DisclosureWidgets
//
//  Created by Tyson Freeze on 3/21/24.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: AppIntentTimelineProvider {
    @MainActor
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),
                    configuration: ConfigurationAppIntent(),
                    streaks: getStreaks())
    }
    
    @MainActor
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(),
                    configuration: configuration,
                    streaks: getStreaks())
    }
    
    @MainActor
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        Timeline(entries: [
            Entry(date: .now, configuration: configuration, streaks: getStreaks())
        ], policy: .never)
    }
    
    @MainActor
    private func getStreaks() -> (Int, Int) {
        guard let modelContainer = try? ModelContainer(for: Relapse.self) else {
            return (0, 0)
        }
        let descriptor = FetchDescriptor<Relapse>(sortBy: [SortDescriptor(\Relapse.date, order: .reverse)])
        let data = try? modelContainer.mainContext.fetch(descriptor)
        
        if let data {
            //three month average streak
            let rollingThreeMonthCount = data.filter {
                $0.date >= Date.now.addingTimeInterval(ChartScale.month.timeInterval * -3)
            }.count

            let averageStreak: Int
            if rollingThreeMonthCount == 0 {
                averageStreak = 0
            } else {
                // either rolling or the furthest the data goes
                averageStreak = (min(ChartScale.month.domain * 3, Int(data.last!.date.timeIntervalSinceNow / -89600.0)) / rollingThreeMonthCount)
            }
            
            //currentStreak
            let currentStreak = Int((data.max(by: { $0.date < $1.date })?.date.timeIntervalSinceNow ?? 0) / (-24*60*60.0))
            
            return (averageStreak, currentStreak)
        }
        
        return (0,0)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let streaks: (Int, Int)
    
    var average: Int { streaks.0 }
    var current: Int { streaks.1 }
    var discreet: Bool { configuration.discreet }
    var metric: MetricType { configuration.metric }
}

struct DisclosureWidgetsEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry
    
    var body: some View {
        Group {
            switch widgetFamily {
            case .systemSmall:
                HStack {
                    MetricView(
                        number: entry.metric == MetricType.current ? entry.current : entry.average,
                        type: entry.metric,
                        discreet: entry.discreet
                    )
                }
                
            case .systemMedium:
                HStack {
                    StreakView(average: entry.average, current: entry.current, discreet: entry.discreet)
                }
                
            case .accessoryRectangular:
                HStack {
                    VStack(alignment: .trailing, spacing: 6) {
                        Text("Days" + (entry.discreet ? "" : " Sober"))
                        Text("Average" + (entry.discreet ? "" : " Days"))
                    }
                    VStack(alignment: .leading) {
                        Text(String(entry.current))
                        Text(String(entry.average))
                    }
                    .font(.system(size: 20))
                    .fontWeight(.heavy)
                }
                
            default:
                Text("Not Implemented")
            }
        }
        .if(entry.configuration.color == .indigo) {
            $0.foregroundStyle(.white)
        }
    }
}

struct DisclosureWidgets: Widget {
    let kind: String = "DisclosureWidgets"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            DisclosureWidgetsEntryView(entry: entry)
                .containerBackground(entry.configuration.color.get, for: .widget)
        }
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryRectangular])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var sample1: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        return intent
    }

    fileprivate static var sample2: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.discreet = true
        intent.color = .indigo
        intent.metric = .average
        return intent
    }
}

#Preview("small", as: .systemSmall) {
    DisclosureWidgets()
} timeline: {
    SimpleEntry(date: .now, configuration: .sample1, streaks: (2, 5))
    SimpleEntry(date: .now, configuration: .sample1, streaks: (102, 105))
    SimpleEntry(date: .now, configuration: .sample2, streaks: (2, 5))
    SimpleEntry(date: .now, configuration: .sample2, streaks: (102, 105))
}

#Preview("med", as: .systemMedium) {
    DisclosureWidgets()
} timeline: {
    SimpleEntry(date: .now, configuration: .sample1, streaks: (2, 5))
    SimpleEntry(date: .now, configuration: .sample1, streaks: (102, 105))
    SimpleEntry(date: .now, configuration: .sample2, streaks: (2, 5))
    SimpleEntry(date: .now, configuration: .sample2, streaks: (102, 105))
}

#Preview("lock", as: .accessoryRectangular) {
    DisclosureWidgets()
} timeline: {
    SimpleEntry(date: .now, configuration: .sample1, streaks: (2, 5))
    SimpleEntry(date: .now, configuration: .sample1, streaks: (102, 105))
    SimpleEntry(date: .now, configuration: .sample2, streaks: (2, 5))
    SimpleEntry(date: .now, configuration: .sample2, streaks: (102, 105))
}
