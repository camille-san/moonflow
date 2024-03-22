//
//  StatisticsTests.swift
//  MoonFlowTests
//
//  Created by Camille on 21/3/24.
//

import XCTest
@testable import MoonFlow

final class AverageCalculationTests: XCTestCase {

    func testAverages() {
        let dateFormatter = getDateFormatter()

        var dates: [Date] = []

        // MARK: Given
        // Period 1 -> Length 5 days

        let date1 = dateFormatter.date(from: "30/10/2023")!
        dates.append(date1)

        // 5 days long period
        for i in 1..<5 {
            let newDate = Calendar.current.date(byAdding: .day, value: i, to: date1)!
            dates.append(newDate)
        }

        // 28 days break from date 1
        let date2 = Calendar.current.date(byAdding: .day, value: 28, to: date1)!
        dates.append(date2)

        // 3 days long period
        for i in 1..<3 {
            let newDate = Calendar.current.date(byAdding: .day, value: i, to: date2)!
            dates.append(newDate)
        }

        // 26 days break from date 2
        let date3 = Calendar.current.date(byAdding: .day, value: 26, to: date2)!
        dates.append(date3)

        // 5 days long period
        for i in 1..<5 {
            let newDate = Calendar.current.date(byAdding: .day, value: i, to: date3)!
            dates.append(newDate)
        }

        // MARK: When
        let results: Results = refreshAveragesAndPredictions(freshSelectedDates: dates)

        // MARK: Then
        XCTAssertEqual(results.newAverageCycleLength, 27, "The average cycle length should be 27 (28+26)/2")
        XCTAssertEqual(results.newAveragePeriodLength, 4, "The average period length should be 4 (5+3+5)/3 -> 4.333 rounded")
    }

    func testAveragesOnlyOnePeriod() {
        let dateFormatter = getDateFormatter()

        var dates: [Date] = []

        // MARK: Given
        // Period 1 -> Length 5 days

        let date1 = dateFormatter.date(from: "30/10/2023")!
        dates.append(date1)

        // 5 days long period
        for i in 1..<5 {
            let newDate = Calendar.current.date(byAdding: .day, value: i, to: date1)!
            dates.append(newDate)
        }

        // MARK: When
        let results: Results = refreshAveragesAndPredictions(freshSelectedDates: dates)

        // MARK: Then
        XCTAssertEqual(results.newAverageCycleLength, 28, "Only one period so no entire cycle -> default value")
        XCTAssertEqual(results.newAveragePeriodLength, 5, "The average period length should be the period length")
    }

}
