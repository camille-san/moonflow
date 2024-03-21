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
    private var userInfosList: FetchedResults<UserInfos>

    @State private var month = Calendar.current.component(.month, from: Date())
    @State private var year = Calendar.current.component(.year, from: Date())

    @State private var dayPositions: [Date : CGRect] = [:]
    @State private var tempSelectedDates : [Date] = []

    private let size : CGFloat = 45
    private let generator = UIImpactFeedbackGenerator(style: .medium)

    private let calendar = Calendar.current
    private let todayMonth = Calendar.current.component(.month, from: Date())
    private let todayYear = Calendar.current.component(.year, from: Date())

    private var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7)

    var body: some View {
        VStack {

            // MARK: Week Days
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

            // MARK: MonthCalendar
            Group {
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
                        .overlay{
                            if day.isFilled && tempSelectedDates.contains(day.date!) {
                                Color.orange
                                    .opacity(0.2)
                                    .clipShape(Circle())
                            }
                        }
                        .overlay {
                            if day.isFilled && calendar.isDateInToday(day.date!) {
                                Circle().stroke(Color.accentColor, lineWidth: 2)
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
            }
            .id("\(month)-\(year)")
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

            // MARK: Month Controller
            HStack {
                Button {
                    previousMonth()
                } label : {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 28))
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
                .foregroundStyle(Color.accentColor)
                Spacer()
                Button {
                    nextMonth()
                } label : {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 28))
                        .foregroundStyle(.black)
                        .padding()
                        .background(.gray.opacity(0.1))
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                }
            }
            .padding()
            //            .background(.accentColor2.opacity(0.1))
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

            // MARK: Today Button
            Button("Today") {
                goToToday()
            }
            Spacer()
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

    private func getUserInfos() -> UserInfos {
        if userInfosList.count > 0 {
            return userInfosList.first!
        } else {
            let newUserInfos = UserInfos(context: self.viewContext)
            saveContext()
            return newUserInfos
        }
    }

    private func onClickDate(dateContainer : DateContainer) {
        if dateContainer.isFilled {
            let date: Date = dateContainer.date!

            generator.prepare()
            if isSelected(date: date) {
                removeDate(date: date)
            } else {
                insertDate(date: date)
            }
            generator.impactOccurred()
            saveNewStatistics(newStats: refreshStatistics(dates: dates.map { $0.date }))
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
            return Calendar.current.isDate(periodDate.date, inSameDayAs: date)
        })
    }

    private func insertDate(date: Date) {
        let newDate = PeriodDate(context: viewContext)
        newDate.date = date
        saveContext()
    }

    private func removeDate(date: Date) {
        if let dateToRemove = dates.first(where: { $0.date == date }) {
            viewContext.delete(dateToRemove)
            saveContext()
        }
    }

    private func saveNewStatistics(newStats: StatisticsResults) {
        getUserInfos().averageCycleLength = Int16(newStats.newAverageCycleLength)
        getUserInfos().averagePeriodLength = Int16(newStats.newAveragePeriodLength)
        saveContext()
    }

    private func goToToday() {
        //        withAnimation(animation) {
        month = todayMonth
        year = todayYear
        //        }
    }

    private func previousMonth() {
        generator.prepare()
        //        withAnimation(animation) {
        if month == 1 {
            month = 12
            year -= 1
        } else {
            month -= 1
        }
        dayPositions = [:]
        generator.impactOccurred()
        //        }
    }

    private func nextMonth() {
        generator.prepare()
        //        withAnimation(animation) {
        if month == 12 {
            month = 1
            year += 1
        } else {
            month += 1
        }
        dayPositions = [:]
        generator.impactOccurred()
        //        }
    }

    private func saveContext() {
        do {
            try self.viewContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }

}

#Preview {
    MonthCalendarScreen()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}