//
//  SettingsScreen.swift
//  MoonFlow
//
//  Created by Camille on 21/3/24.
//

import SwiftUI

struct SettingsScreen: View {

    @Environment(\.managedObjectContext) private var viewContext

    @Binding var isSheetOpened: Bool
    @Binding var predictions: [Date]

    @State private var tempNotificationsEnabled = true
    @State private var daysBeforeNotifications = 0
    @State private var timeOfNotifications: Date = Date()

    @FetchRequest(sortDescriptors: [])
    private var settings: FetchedResults<UserSettings>
    @FetchRequest(sortDescriptors: [])
    private var averages: FetchedResults<UserAverages>
    @FetchRequest(sortDescriptors: [])
    private var periodDates: FetchedResults<PeriodDate>
    @FetchRequest(sortDescriptors: [])
    private var infos: FetchedResults<UserInfos>

    private let height: CGFloat = 45

    var body: some View {
        VStack {
            Color.gray.opacity(0.3)
                .clipShape(
                    RoundedRectangle(cornerRadius: 32))
                .frame(width: 70, height: 5)
                .padding(.top, 24)
            HStack (alignment: .top) {
                Button("Close") {
                    isSheetOpened = false
                }
                Spacer()
                Button("Save") {
                    updateSettings()
                }
            }
            .padding(.horizontal, 24)

            Text("Settings")
                .font(.title)
                .bold()
            if !settings.isEmpty {
                List {
                    HStack {
                        Toggle("Notifications enabled", isOn: $tempNotificationsEnabled)
                    }
                    .frame(height: height)
                    HStack{
                        Group {
                            Text("\(daysBeforeNotifications)")
                                .foregroundStyle(.accent)
                            Text("day(s) before")
                        }
                        .font(.system(size: 18))
                        Spacer()
                        Stepper(
                            "",
                            value: $daysBeforeNotifications,
                            in: 0...4,
                            step: 1
                        )
                        .labelsHidden()
                    }
                    .frame(height: height)
                    HStack{
                        Group {
                            Text("Time of notification")
                        }
                        .font(.system(size: 18))
                        Spacer()
                        DatePicker(
                            "Start Date",
                            selection: $timeOfNotifications,
                            displayedComponents: [.hourAndMinute]
                        )
                        .labelsHidden()
                    }
                    .frame(height: height)
                    HStack {
                        Button("Print notif") {
                            printNotifications()
                        }
                    }
                    .frame(height: height)
                    HStack {
                        Button("Delete all data") {
                            deleteData()
                        }
                        .foregroundStyle(.red)
                    }
                    .frame(height: height)
                }
                .listStyle(.inset)
            }
            Spacer()
        }
        .onAppear {
            tempNotificationsEnabled = getUserSettings().isNotificationEnabled
            daysBeforeNotifications = Int(getUserSettings().daysBeforeNotification)
            let components = DateComponents(
                hour: Int(getUserSettings().hourOfNotification),
                minute: Int(getUserSettings().minutesOfNotification))
            timeOfNotifications = calendar.date(from: components)!
        }
    }


    private func getUserSettings() -> UserSettings {
        return settings.first!
    }

    private func updateSettings() {
        let userSettings = getUserSettings()

        // if we activate notifications and they were not allowed before
//        if !userSettings.isNotificationEnabled && tempNotificationsEnabled {
//
//            var isAuthorized = true
//            UNUserNotificationCenter.current().getNotificationSettings { settings in
//                isAuthorized = settings.authorizationStatus == .authorized
//            }
//
//            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
//                isAuthorized = success
//            }
//
//        }

        userSettings.isNotificationEnabled = tempNotificationsEnabled
        userSettings.daysBeforeNotification = Int16(daysBeforeNotifications)

        if userSettings.isNotificationEnabled && !predictions.isEmpty {
            print("CREATING NOTIFICATION IN SETTINGS")

            let dateOfNotification = calculateDayOfNotification(
                dayOfFirstPredictedPeriod: predictions.first!,
                settings: getUserSettings())

            print("FIRST DATE OF PREDICTIONS: \(getDateFormatter().string(from: predictions.first!))")
            print("DAYS BEFORE \(userSettings.daysBeforeNotification)")
            print("DATE OF NOTIF: \(getDateFormatterWithTime().string(from: dateOfNotification))")

            emptyAndAddNewNotification(dateOfNotification: dateOfNotification, settings: getUserSettings())
        } else {
            cancelAllNotifications()
        }

        let hour = calendar.component(.hour, from: timeOfNotifications)
        let minutes = calendar.component(.minute, from: timeOfNotifications)

        userSettings.hourOfNotification = Int16(hour)
        userSettings.minutesOfNotification = Int16(minutes)

        saveContext(viewContext)
        isSheetOpened = false
    }

    private func deleteData() {
        infos.first!.isReady = false

        for period in periodDates {
            viewContext.delete(period)
        }

        for av in averages {
            viewContext.delete(av)
        }

        for set in settings {
            viewContext.delete(set)
        }

        saveContext(viewContext)
        cancelAllNotifications()
    }

}

#Preview {
    SettingsScreen(isSheetOpened: .constant(true), predictions: .constant([Date]()))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
