//
//  PredictionHelper.swift
//  MoonFlow
//
//  Created by Camille on 22/3/24.
//

import Foundation

func predictNextYearPeriods(lastPeriod dates: [Date], averageCycleLength: Int, averagePeriodLength: Int) -> [Date] {
    
    var nextPredictedPeriodDays = [Date]()
    
    // Complete last selected period if needed
    if dates.count < averagePeriodLength {
        let count = averagePeriodLength - dates.count
        let lastDate = dates.last!
        let nextPredictedLastDay = lastDate.addingDays(count)
        let nextPredictedStartDay = lastDate.addingDays(1)
        nextPredictedPeriodDays += datesBetween(startDate: nextPredictedStartDay, endDate: nextPredictedLastDay)
    }
    
    var lastFirstDay: Date = dates.first!
    
    // For 12 months
    for _ in 1...12 {
        let nextPredictedFirstDay = lastFirstDay.addingDays(averageCycleLength)
        //        let nextPredictedFirstDay = calendar.date(byAdding: .day, value: averageCycleLength, to: lastFirstDay)!
        
        // periodLength -1 because the first day is already included
        let nextPredictedLastDay = nextPredictedFirstDay.addingDays(averagePeriodLength-1)
        //        let nextPredictedLastDay = calendar.date(byAdding: .day, value: averagePeriodLength-1, to: nextPredictedFirstDay)!
        
        nextPredictedPeriodDays += datesBetween(startDate: nextPredictedFirstDay, endDate: nextPredictedLastDay)
        lastFirstDay = nextPredictedFirstDay
    }
    
    return nextPredictedPeriodDays
    
}
