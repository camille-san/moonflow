//
//  NotificationsHelper.swift
//  MoonFlow
//
//  Created by Camille on 24/3/24.
//

import Foundation
import UserNotifications

func cancelNotificationsById(ids: [String]) {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
}

func cancelAllNotifications() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
}

func emptyAndAddNewNotification(dateOfNotification: Date, settings: UserSettings) {
    cancelAllNotifications()

    if dateOfNotification >= Date() {

        let content = UNMutableNotificationContent()
        let daysUntilPeriod = settings.daysBeforeNotification

        content.title = "MoonFlow"
        if daysUntilPeriod == 0 {
            content.body = "Possiblity to get your period today"
        } else if daysUntilPeriod == 1 {
            content.body = "Possibility to get your period tomorrow"
        } else {
            content.body = "Possibility to get your period in \(daysUntilPeriod) days"
        }
        content.sound = .default

        print("Date of notification: \(getDateFormatterWithTime().string(from: dateOfNotification))")

        var dateComponents = DateComponents()
        dateComponents.year = calendar.component(.year, from: dateOfNotification)
        dateComponents.month = calendar.component(.month, from: dateOfNotification)
        dateComponents.day = calendar.component(.day, from: dateOfNotification)
        dateComponents.hour = calendar.component(.hour, from: dateOfNotification)
        dateComponents.minute = calendar.component(.minute, from: dateOfNotification)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let id = UUID().uuidString

        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    } else {
        print("date of notification before today -> no new notification request")
    }
    printNotifications()
}

func calculateDayOfNotification(dayOfFirstPredictedPeriod: Date, settings: UserSettings) -> Date {
    let dateOfNotification = dayOfFirstPredictedPeriod.addingDays(-Int(settings.daysBeforeNotification))

    let components = DateComponents(
        year: calendar.component(.year, from: dateOfNotification),
        month: calendar.component(.month, from: dateOfNotification),
        day: calendar.component(.day, from: dateOfNotification),
        hour: Int(settings.hourOfNotification),
        minute: Int(settings.minutesOfNotification))

    return calendar.date(from: components)!
}

func printNotifications() {
    UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
        for request in requests {
            if let calendarTrigger = request.trigger as? UNCalendarNotificationTrigger,
               let triggerDate = calendarTrigger.nextTriggerDate() {
                print("Trigger date: \(getDateFormatterWithTime().string(from: triggerDate))")
            } else if let timeIntervalTrigger = request.trigger as? UNTimeIntervalNotificationTrigger,
                      let triggerDate = timeIntervalTrigger.nextTriggerDate() {
                print("Trigger date: \(getDateFormatterWithTime().string(from: triggerDate))")
            } else {
                print("Trigger type is not calendar or time interval")
            }
        }
    }
}
