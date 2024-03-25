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

func refreshAveragesAndPredictions(freshSelectedDates dates: [Date], oldAveragePeriodLength: Int, oldAverageCycleLength: Int) -> Results {

    print("==== RECALCUL AVERAGES & PREDICTIONS")
    print("Old period length: \(oldAveragePeriodLength)")
    print("Old cycle length: \(oldAverageCycleLength)")

    // From the array of dates, we create periods of time
    var periods: [Period] = extractPeriods(dates: dates)
    let lastPeriod = periods.last! // we save it separated for later

    if periods.count > 1 && periods.last!.dates.count < oldAveragePeriodLength {

        // we ignore the last "ongoing" period to not bias average
        print("Ignoring last period: [\(getDateFormatter().string(from: periods.last!.startDate)) - (\(periods.last!.dates.count)) - \(getDateFormatter().string(from: periods.last!.endDate))]")
        periods.removeLast()

    }

    for p in periods {
        print("Period: [\(getDateFormatter().string(from: p.startDate)) - (\(p.dates.count)) - \(getDateFormatter().string(from: p.endDate))]")
    }

    var averagePeriodLength = oldAveragePeriodLength
    var averageCycleLength = oldAverageCycleLength


    if periods.count > 1 {

        print("Calculating new averages...")
        averageCycleLength = calculateAverageCycleLength(periods: periods)
        averagePeriodLength = calculateAveragePeriodLength(periods: periods)

    } else if periods.count == 1 && periods.first!.dates.count > oldAveragePeriodLength {

        // If there's only one period entered and it's bigger than the registered average period length, we update it
        averagePeriodLength = periods.first!.dates.count

    }

    let predictions = predictNextYearPeriods(
        lastPeriod: lastPeriod.dates,
        averageCycleLength: averageCycleLength,
        averagePeriodLength: averagePeriodLength)

    return Results(
        newAverageCycleLength: averageCycleLength,
        newAveragePeriodLength: averagePeriodLength,
        predictions: predictions)
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

        print("+ Period lengths to average: \(periodLengths)")

        let sum = periodLengths.reduce(0, +)
        let average = Double(sum) / Double(periodLengths.count)

        print("+ Period lengths result: \(average)")

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

            let durationBetween = calendar.dateComponents([.day], from: previousDate, to: currentDate)
            print("Calculating interval between [\(getDateFormatterWithTime().string(from: previousDate))] - [\(getDateFormatterWithTime().string(from: currentDate))] => \(durationBetween)")
            if let numberOfDays = durationBetween.day {
                intervals.append(numberOfDays)
            }

        }

        print("+ Cycle lengths to average: \(intervals)")

        let sum = intervals.reduce(0, +)
        let average = Double(sum) / Double(intervals.count)

        print("+ Cycle lengths result: \(average)")

        return Int(round(average))

    }
    return 28
}
