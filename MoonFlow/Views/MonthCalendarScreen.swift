//
//  MonthCalendarScreen.swift
//  MoonFlow
//
//  Created by Camille on 21/3/24.
//

import SwiftUI
import CoreData

struct MonthCalendarScreen: View {

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [])
    private var dates: FetchedResults<PeriodDate>
    @FetchRequest(sortDescriptors: [])
    private var userAverages: FetchedResults<UserAverages>
    @FetchRequest(sortDescriptors: [])
    private var userSettings: FetchedResults<UserSettings>

    @Binding var predictions: [Date]

    @State private var month = calendar.component(.month, from: Date())
    @State private var year = calendar.component(.year, from: Date())

//    @State private var dayPositions: [Date : CGRect] = [:]
//    @State private var tempSelectedDates: [Date] = []

    private let size: CGFloat = 40
    private let generator = UIImpactFeedbackGenerator(style: .light)

    private let todayMonth = calendar.component(.month, from: Date())
    private let todayYear = calendar.component(.year, from: Date())

    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7)

    var body: some View {
        VStack {

            // --------------------------------------------------------------------------------
            // MARK: Week Days Columns
            LazyVGrid(columns: columns, spacing: 20) {
                Group {
                    Text("M")
                    Text("T")
                    Text("W")
                    Text("T")
                    Text("F")
                    Text("S")
                    Text("S")
                }
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .bold()
            }
            .padding(.horizontal)

            // --------------------------------------------------------------------------------
            // MARK: Month Calendar
            LazyVGrid(columns: columns) {
                ForEach(getDays(month: month, year: year)) { day in
                    Group {
                        if day.isFilled {
                            Text("\(day.dayOfMonth!)")
                                .frame(width: size, height: size)
                                .background(
                                    isSelected(date: day.date!) ? Color.accentColor :
                                            .white)
                                .foregroundStyle(isSelected(date: day.date!) ? .white :
                                        .black)
                            //                                .onAppear {
                            //                                    self.rectPosition?(geometry.frame(in: .global))
                            //                                }
                        } else {
                            Text("")
                                .frame(width: size, height: size)
                                .background(.clear)
                        }
                    }
                    .font(.system(size: 16,
                                  weight: .medium))
                    .clipShape(Circle())
//                    .overlay{
//                        if day.isFilled && tempSelectedDates.contains(day.date!) {
//                            Color.yellow
//                                .opacity(0.2)
//                                .clipShape(Circle())
//                        }
//                    }
                    .overlay {
                        if day.isFilled && calendar.isDateInToday(day.date!) {
                            Circle().stroke(Color.accentColor, lineWidth: 2)
                        }
                    }
                    .overlay {
                        if day.isFilled && isPredicted(date: day.date!) {
                            Circle().stroke(Color.accentColor, style: StrokeStyle(lineWidth: 2, dash: [5]))
                        }
                    }
                    .frame(width: size, height: size)
                    .onTapGesture {onClickDate(dateContainer: day)}
                }
            }
            .padding()
            .background(.accentColor2.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.top, 18)
            //        .gesture(DragGesture()
            //            .onChanged { value in
            //                selectDatesBasedOnCGPoints(
            //                    startPoint: value.startLocation,
            //                    endPoint: value.location)
            //            }
            //            .onEnded {value in
            //                selectDatesBasedOnCGPoints(
            //                    startPoint: value.startLocation,
            //                    endPoint: value.location)
            //                selectDateRange()
            //            }
            //        )

            // --------------------------------------------------------------------------------
            // MARK: Month Controller
            HStack {
                Button {
                    previousMonth()
                } label : {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .foregroundStyle(.black)
                        .padding()
                        .background(.gray.opacity(0.1))
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                }
                Spacer()
                Group {
                    Text("\(Month(monthIndex: month)!.monthName)")
                    Text("\(String(year))")
                }
                .font(.system(size: 24))
                Spacer()
                Button {
                    nextMonth()
                } label : {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20))
                        .foregroundStyle(.black)
                        .padding()
                        .background(.gray.opacity(0.1))
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                }
            }
            .padding()
            .clipShape(RoundedRectangle(cornerRadius: 15))
            //        .gesture(DragGesture()
            //            .onChanged { value in
            //                selectDatesBasedOnCGPoints(
            //                    startPoint: value.startLocation,
            //                    endPoint: value.location)
            //            }
            //            .onEnded {value in
            //                selectDatesBasedOnCGPoints(
            //                    startPoint: value.startLocation,
            //                    endPoint: value.location)
            //                selectDateRange()
            //            }
            //        )

            // --------------------------------------------------------------------------------
            // MARK: Today Button
            Button("Today") {
                withAnimation(.easeInOut) {
                    goToToday()
                }
            }

            // UNCOMMENT TO DEBUG
            //            ScrollView {
            //                ForEach(dates, id: \.id) { date in
            //                    Text(getDateFormatterWithTime().string(from: date.date))
            //                }
            //            }
            Spacer()
        }
        .onAppear {
            append1YearPredicted(fromDates: dates.map { $0.date })
        }
        .padding(.top, 48)
        .padding(.horizontal)
        .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onEnded { value in
                if value.translation.width > 0 && abs(value.translation.height) < 100 {
                    previousMonth()
                } else if value.translation.width < 0 && abs(value.translation.height) < 100 {
                    nextMonth()
                }
            }
        )
    }

    private func onClickDate(dateContainer : DateContainer) {
        if dateContainer.isFilled {
            let date: Date = dateContainer.date!

            generator.prepare()
            if isSelected(date: date) {
                removeDate(date)
            } else {
                insertDate(date)
            }
            generator.impactOccurred()

            saveNewAveragesAndPredictions(
                freshResults:
                    refreshAveragesAndPredictions(
                        freshSelectedDates: dates.map { $0.date },
                        oldAveragePeriodLength: Int(userAverages.first!.averagePeriodLength),
                        oldAverageCycleLength: Int(userAverages.first!.averageCycleLength)))
        }
    }

    //    private func selectDatesBasedOnCGPoints(startPoint : CGPoint, endPoint: CGPoint) {
    //        generator.prepare()
    ////        let newStartPoint = CGPoint(x: startPoint.x, y: startPoint.y + (2*size))
    //        let newStartPoint = CGPoint(x: startPoint.x, y: startPoint.y)
    ////        let newEndPoint = CGPoint(x: endPoint.x, y: endPoint.y + (2*size))
    //        let newEndPoint = CGPoint(x: endPoint.x, y: endPoint.y)
    //
    //        var startDate : Date?
    //        var endDate : Date?
    //        for (date, cgRect) in dayPositions {
    //            if cgRect.contains(newStartPoint) {
    //                startDate = date
    //            } else if cgRect.contains(newEndPoint) {
    //                endDate = date
    //            }
    //
    //            if let unwrappedStartDate = startDate, let unwrappedEndDate = endDate {
    //                let selectedDates = datesBetween(startDate: unwrappedStartDate, endDate: unwrappedEndDate)
    //                if selectedDates.count > tempSelectedDates.count {
    //                    generator.impactOccurred()
    //                }
    //                tempSelectedDates = selectedDates
    //                break
    //            }
    //        }
    //    }

    //    private func selectDateRange() {
    //        if !tempSelectedDates.isEmpty {
    //            statisticsServiceeee.handleSeveralDates(dates: tempSelectedDates)
    //            tempSelectedDates = []
    //        }
    //    }

    private func isSelected(date: Date) -> Bool {
        return dates.contains(where: { periodDate in
            return calendar.isDate(periodDate.date, inSameDayAs: date)
        })
    }

    private func isPredicted(date: Date) -> Bool {
        return predictions.contains(where: { predictedDate in
            return calendar.isDate(predictedDate, inSameDayAs: date)
        })
    }

    private func append1YearPredicted(fromDates: [Date]) {
        if !dates.isEmpty {
            let currentDatesAsPeriods = extractPeriods(dates: fromDates)
            let lastPeriod = currentDatesAsPeriods.last!
            predictions +=
            predictNextYearPeriods(
                lastPeriod: lastPeriod.dates,
                averageCycleLength: Int(userAverages.first!.averageCycleLength),
                averagePeriodLength: Int(userAverages.first!.averagePeriodLength))
        }
    }

    private func insertDate(_ date: Date) {
        let newDate = PeriodDate(context: viewContext)
        newDate.date = date
        saveContext(viewContext)
    }

    private func removeDate(_ date: Date) {
        if let dateToRemove = dates.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            viewContext.delete(dateToRemove)
            saveContext(viewContext)
        }
    }

    private func saveNewAveragesAndPredictions(freshResults: Results) {
        predictions = freshResults.predictions

        userAverages.first!.averageCycleLength = Int16(freshResults.newAverageCycleLength)
        userAverages.first!.averagePeriodLength = Int16(freshResults.newAveragePeriodLength)
        saveContext(viewContext)

createNotification()
    }

    private func createNotification() {
        if !predictions.isEmpty && userSettings.first!.isNotificationEnabled {
            let dateOfNotification = calculateDayOfNotification(
                dayOfFirstPredictedPeriod: predictions.first!,
                settings: userSettings.first!)
            emptyAndAddNewNotification(dateOfNotification: dateOfNotification, settings: userSettings.first!)
        }
    }

    private func goToToday() {
        month = todayMonth
        year = todayYear
    }

    private func previousMonth() {
//        generator.prepare()
        if month == 1 {
            month = 12
            year -= 1
        } else {
            month -= 1
        }
//        dayPositions = [:]
//        generator.impactOccurred()
    }

    private func nextMonth() {
//        generator.prepare()
        if month == 12 {
            month = 1
            year += 1
        } else {
            month += 1
        }
//        dayPositions = [:]
//        generator.impactOccurred()

        if !dates.isEmpty {
            let lastDayOfPrediction: Date = predictions.last!

            if month == calendar.component(.month, from: lastDayOfPrediction) {
                append1YearPredicted(fromDates: predictions)
            }
        }
    }
    
}

#Preview {
    MonthCalendarScreen(predictions: .constant([Date]()))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
