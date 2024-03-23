//
//  DateHelper.swift
//  MoonFlow
//
//  Created by Camille on 21/3/24.
//

import Foundation

extension Date {
    func addingDays(_ days: Int) -> Date {
        if let nextDay: Date = calendar.date(byAdding: .day, value: days, to: self) {
            return nextDay
        } else {
            fatalError("Error when trying to add \(days) days to a Date \(getDateFormatter().string(from: self))")
        }
    }
}

let calendar = Calendar.current

func getDays(month : Int, year : Int) -> [DateContainer] {
    var dates: [DateContainer] = []
    
    var components = DateComponents()
    components.year = year
    components.month = month
    
    let firstDayOfMonth = calendar.date(from: components)
    
    let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth!)
    
    for day in (range!) {
        var newComponents = DateComponents()
        newComponents.year = year
        newComponents.month = month
        newComponents.day = day
        let newDate = calendar.date(from: newComponents)
        dates.append(DateContainer(isFilled: true, date: newDate))
    }
    
    return fillUpMonthToStartOnMonday(monthDays: dates)
}

private func fillUpMonthToStartOnMonday(monthDays dates : [DateContainer]) -> [DateContainer] {
    var newDatesArray : [DateContainer] = []
    
    var times = 0
    
    switch dates[0].dayOfWeek {
    case .tuesday:
        times = 1
    case .wednesday:
        times = 2
    case .thursday:
        times = 3
    case .friday:
        times = 4
    case .saturday:
        times = 5
    case .sunday:
        times = 6
    default:
        return dates
    }
    
    for _ in 1...times {
        newDatesArray.append(DateContainer(isFilled: false))
    }
    
    newDatesArray.append(contentsOf: dates)
    return newDatesArray
}

func datesBetween(startDate: Date, endDate: Date) -> [Date] {
    var dates: [Date] = []
    var currentDate = startDate
    
    if startDate > endDate {
        return datesBetween(startDate: endDate, endDate: startDate)
    }
    
    if startDate == endDate {
        dates.append(startDate)
        return dates
    }
    
    while currentDate <= endDate {
        dates.append(currentDate)
        currentDate = currentDate.addingDays(1)
        //        if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
        //            currentDate = nextDate
        //        } else {
        //            break
        //        }
    }
    
    return dates
}

func areDatesConsecutive(firstDate: Date, secondDate: Date) -> Bool {
    if firstDate > secondDate {
        return areDatesConsecutive(firstDate: secondDate, secondDate: firstDate)
    }
    
    //    let nextDay = calendar.date(byAdding: .day, value: 1, to: firstDate)
    return calendar.isDate(firstDate.addingDays(1), inSameDayAs: secondDate)
}

func getDateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    dateFormatter.locale = Locale.current
    return dateFormatter
}
