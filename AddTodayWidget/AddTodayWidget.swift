//
//  AddTodayWidget.swift
//  AddTodayWidget
//
//  Created by Camille on 25/3/24.
//

import WidgetKit
import SwiftUI
import CoreData

struct SimpleProvider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let entry = SimpleEntry(date: Date())
        // Use a distant future date for the expiration to effectively make the widget static
        let expirationDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(expirationDate))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct AddTodayWidgetEntryView : View {

    //    var entry: Provider.Entry
    @ObservedObject var dataManager: DataManager

    //    init(entry: Provider.Entry, persistenceController: PersistenceController? = nil) {
    init(persistenceController: PersistenceController? = nil) {
        //        self.entry = entry
        if let controller = persistenceController {
            self._dataManager = ObservedObject(initialValue: DataManager(context: controller.container.viewContext))
        } else {
            self._dataManager = ObservedObject(initialValue: DataManager(context: PersistenceController.shared.container.viewContext))
        }
    }

    var body: some View {
        VStack (spacing: 18){
            if dataManager.userInfos == nil {
                Image(systemName: "exclamationmark.circle")
                    .foregroundStyle(.red)
            } else {
                Text("\(dataManager.userInfos!.name ?? "No name")").bold()
            }
            if dataManager.userAverages == nil {
                Image(systemName: "exclamationmark.circle")
                    .foregroundStyle(.red)
            } else {
                HStack {
                    Text("\(dataManager.userAverages!.averagePeriodLength)")
                    Text("\(dataManager.userAverages!.averageCycleLength)")
                }
            }
        }
        .foregroundStyle(.pink)
    }
}

struct AddTodayWidget: Widget {
    let kind: String = "AddTodayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SimpleProvider()) { _ in
            if #available(iOS 17.0, *) {
                AddTodayWidgetEntryView()
                    .containerBackground(.white, for: .widget)
            } else {
                AddTodayWidgetEntryView()
                    .padding()
                    .background(.white)
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

struct AddTodayWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodayWidgetEntryView(persistenceController: .preview)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
