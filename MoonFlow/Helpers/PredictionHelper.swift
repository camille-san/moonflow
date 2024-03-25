//
//  PredictionHelper.swift
//  MoonFlow
//
//  Created by Camille on 22/3/24.
//

import Foundation

func predictNextYearPeriods(lastPeriod dates: [Date], averageCycleLength: Int, averagePeriodLength: Int) -> [Date] {
    
    var nextPredictedPeriodDays = [Date]()
    
    // Last selected period could be incomplete because it is still ongoing
    // We need to predict the incoming days based on the known average then
    if dates.count < averagePeriodLength {

        let count = averagePeriodLength - dates.count
        let lastDate = dates.last!
        let nextPredictedLastDay = lastDate.addingDays(count)
        let nextPredictedStartDay = lastDate.addingDays(1)
        nextPredictedPeriodDays += datesBetween(startDate: nextPredictedStartDay, endDate: nextPredictedLastDay)
        
    }
    
    // We take the first day of the last period to add it the average cycle for the first prediction
    var lastFirstDay: Date = dates.first!
    
    // For 12 months
    for _ in 1...12 {
        let nextPredictedFirstDay = lastFirstDay.addingDays(averageCycleLength)
        
        // periodLength -1 because the first day is already included
        let nextPredictedLastDay = nextPredictedFirstDay.addingDays(averagePeriodLength-1)
        
        nextPredictedPeriodDays += datesBetween(startDate: nextPredictedFirstDay, endDate: nextPredictedLastDay)
        lastFirstDay = nextPredictedFirstDay
    }
    
    return nextPredictedPeriodDays
    
}
