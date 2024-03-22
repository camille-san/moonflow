//
//  StatisticsHelper.swift
//  MoonFlow
//
//  Created by Camille on 21/3/24.
//

import Foundation

struct Period {
    var startDate: Date
    var endDate: Date
    var dates: [Date]

    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
        dates = datesBetween(startDate: startDate, endDate: endDate)
    }
}

struct Results {
    var newAverageCycleLength: Int
    var newAveragePeriodLength: Int
    var predictions: [Date]
}

func refreshAveragesAndPredictions(freshSelectedDates dates: [Date]) -> Results {
    let periods : [Period] = extractPeriods(dates: dates)

    for d in periods.last!.dates {
        print("+++ \(getDateFormatter().string(from: d))")
    }


    let averageCycleLength = calculateAverageCycleLength(periods: periods)
    let averagePeriodLength = calculateAveragePeriodLength(periods: periods)
    let predictions = predictNextYearPeriods(
        lastPeriod: periods.last!.dates,
        averageCycleLength: averageCycleLength,
        averagePeriodLength: averagePeriodLength)

    var results = Results(
        newAverageCycleLength: averageCycleLength,
        newAveragePeriodLength: averagePeriodLength,
        predictions: predictions)

    return results
}

func extractPeriods(dates: [Date]) -> [Period] {
    let sortedDates : [Date] = dates.sorted(by: { $0 < $1 })

    var subsets: [[Date]] = []
    var currentSubset: [Date] = []

    for (index, date) in sortedDates.enumerated() {
        if currentSubset.isEmpty {
            currentSubset.append(date)
        } else if index < sortedDates.count, areDatesConsecutive(firstDate: currentSubset.last!, secondDate: date) {
            // is consecutive -> we add to current period
            currentSubset.append(date)
        } else {
            // is not consecutive -> we create a new period
            subsets.append(currentSubset)
            currentSubset = [date]
        }
    }

    if !currentSubset.isEmpty {
        subsets.append(currentSubset)
    }

    var periods : [Period] = []

    for subset in subsets {
        periods.append(Period(startDate: subset.first!, endDate: subset.last!))
    }
    return periods
}

private func calculateAveragePeriodLength(periods: [Period]) -> Int {
    if periods.count > 1 {

        var periodLengths = [Int]()

        for i in 0..<periods.count {
            periodLengths.append(periods[i].dates.count)
        }

        let sum = periodLengths.reduce(0, +)
        let average = Double(sum) / Double(periodLengths.count)

        return Int(round(average))

    } else if periods.count == 1 {

        return periods.first!.dates.count

    }

    return 7
}

private func calculateAverageCycleLength(periods: [Period]) -> Int {
    if periods.count > 1 {

        var intervals = [Int]()
        
        for i in 1..<periods.count {

            let previousDate = periods[i - 1].startDate
            let currentDate = periods[i].startDate

            let durationBetween = Calendar.current.dateComponents([.day], from: previousDate, to: currentDate)
            if let day = durationBetween.day {
                intervals.append(day)
            }

        }

        let sum = intervals.reduce(0, +)
        let average = Double(sum) / Double(intervals.count)

        return Int(round(average))

    }
    return 28
}
