//
//  DateContainer.swift
//  MoonFlow
//
//  Created by Camille on 21/3/24.
//

import Foundation

struct DateContainer: Identifiable, Hashable {
    
    let id = UUID()
    var isFilled: Bool
    var dayOfWeek: DayOfWeek?
    var dayOfMonth: Int?
    var month: Month?
    var year: Int?
    var date: Date?
    
    init(isFilled: Bool, date: Date? = nil) {
        
        self.isFilled = isFilled
        
        if isFilled {
            let unwrappedDate = date!
            let day = calendar.component(.day, from: unwrappedDate)
            let year = calendar.component(.year, from: unwrappedDate)
            
            self.dayOfWeek = getWeekday(date: unwrappedDate)
            self.dayOfMonth = day
            self.month = getMonth(date: unwrappedDate)
            self.year = year
            self.date = unwrappedDate
        }
    }
    
    private func getWeekday(date: Date) -> DayOfWeek {
        let weekday = calendar.component(.weekday, from: date)
        return DayOfWeek(dayIndex: weekday)!
    }
    
    private func getMonth(date: Date) -> Month {
        let month = calendar.component(.month, from: date)
        return Month(monthIndex: month)!
    }
    
}
