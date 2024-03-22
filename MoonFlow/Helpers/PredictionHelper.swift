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
        let nextPredictedLastDay = calendar.date(byAdding: .day, value: count, to: dates.last!)!
        nextPredictedPeriodDays += datesBetween(startDate: dates.last!, endDate: nextPredictedLastDay)
    }

    var lastFirstDay: Date = dates.first!

    // For 12 months
    for _ in 1...12 {
        print("===============")
        let nextPredictedFirstDay = calendar.date(byAdding: .day, value: averageCycleLength, to: lastFirstDay)!
        print("\(getDateFormatter().string(from: lastFirstDay)) + \(averageCycleLength) = \(getDateFormatter().string(from: nextPredictedFirstDay))")

        // periodLength -1 because the first day is already included
        let nextPredictedLastDay = calendar.date(byAdding: .day, value: averagePeriodLength-1, to: nextPredictedFirstDay)!
        print("\(getDateFormatter().string(from: nextPredictedFirstDay)) + \(averagePeriodLength-1) = \(getDateFormatter().string(from: nextPredictedLastDay))")

        nextPredictedPeriodDays += datesBetween(startDate: nextPredictedFirstDay, endDate: nextPredictedLastDay)
        lastFirstDay = nextPredictedFirstDay
    }

    return nextPredictedPeriodDays

}
