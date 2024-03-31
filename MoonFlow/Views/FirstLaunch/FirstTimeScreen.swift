//
//  FirstTimeScreen.swift
//  MoonFlow
//
//  Created by Camille on 22/3/24.
//

import SwiftUI

struct FirstTimeScreen: View {

    @Environment(\.managedObjectContext) private var viewContext

    @State private var progress: Int = 0
    @State private var offset = CGSize.zero

    @State private var firstDayLastPeriod: Date?
    @State private var tempDate: Date = Date()
    @State private var tempPeriodLength: Int = 7
    @State private var tempCycleLength: Int = 28
    @State private var areNotificationsEnabled = false
    @State private var daysBeforeNotifications = 1
    @State private var timeOfNotifications: Date = {
        let components = DateComponents(hour: 9, minute: 0)
        return calendar.date(from: components) ?? Date()
    }()
    @State private var partyScale: CGFloat = 22
    @State private var offsetX: CGFloat = 0

    @FetchRequest(sortDescriptors: [])
    private var userInfos: FetchedResults<UserInfos>

    private let screensCount = 8

    var body: some View {

        VStack {
            GeometryReader { geometry in
                HStack(spacing: 0) {

                    WelcomeScreen(
                        changeViewAction: changeView)
                    .padding(.horizontal, 28)
                    .frame(width: geometry.size.width, height: geometry.size.height)

                    AppIntroductionScreen(
                        currentIndex: $progress,
                        changeViewAction: changeView)
                    .padding(.horizontal, 28)
                    .frame(width: geometry.size.width, height: geometry.size.height)

                    LastPeriodScreen(
                        changeViewAction: changeView,
                        firstDayLastPeriod: $firstDayLastPeriod)
                    .padding(.horizontal, 28)
                    .frame(width: geometry.size.width, height: geometry.size.height)

                    PeriodLengthScreen(
                        changeViewAction: changeView,
                        periodLength: $tempPeriodLength)
                    .padding(.horizontal, 28)
                    .frame(width: geometry.size.width, height: geometry.size.height)

                    CycleLengthScreen(
                        changeViewAction: changeView,
                        cycleLength: $tempCycleLength)
                    .padding(.horizontal, 28)
                    .frame(width: geometry.size.width, height: geometry.size.height)

                    RemindersSetupScreen(
                        changeViewAction: changeView,
                        areNotificationsEnabled: $areNotificationsEnabled,
                        reminderDaysBeforePeriod: .constant(2),
                        hourOfPeriodReminder: .constant(9),
                        minutesOfPeriodReminder: .constant(15))
                    .padding(.horizontal, 28)
                    .frame(width: geometry.size.width, height: geometry.size.height)

                    LocationSetupScreen(
                        changeViewAction: changeView)
                    .padding(.horizontal, 28)
                    .frame(width: geometry.size.width, height: geometry.size.height)

                    // --------------------------------------------------------------------------------
                    // MARK: Ready

                    VStack (spacing: 24) {
                        Text("🎉")
                            .font(.system(size: partyScale))
                            .onAppear {
                                let duration: CGFloat = 0.3
                                let partyAnimation = Animation.easeInOut(duration: duration)

                                withAnimation(partyAnimation) {
                                    partyScale = 50
                                }
                                withAnimation(partyAnimation.delay(duration)) {
                                    partyScale = 42
                                }
                            }
                        Button {
                            makeReady()
                        } label: {
                            Text("Let's start")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 12)
                                .background(.accent)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding(.horizontal, 28)
                    .frame(width: geometry.size.width, height: geometry.size.height)

                }
                .offset(x: self.offset.width - (CGFloat(self.progress) * geometry.size.width), y: 0)
                .animation(.easeInOut, value: offset)
                .animation(.easeInOut, value: progress)
            }
        }
        .background(.BGCOLOR)
        .font(.system(.title, design: .rounded))

    }

    private func getProgressColor(_ step: Int) -> Color {
        return progress >= step ? .accentColor : .gray.opacity(0.5)
    }

    private func getUserInfos() -> UserInfos {
        if let infos: UserInfos = userInfos.first {
            return infos
        } else {
            fatalError("Initialization of database error")
        }
    }

    func changeView(direction: SlideDirection) {

        if direction == .right {
            progress += 1
            offsetX -= 70
        } else {
            progress -= 1
            offsetX -= 70
        }
        offset = .zero
    }

    private func makeReady() {
        let userSettings = UserSettings(context: viewContext)
        userSettings.isNotificationEnabled = areNotificationsEnabled

        let hour = calendar.component(.hour, from: timeOfNotifications)
        let minutes = calendar.component(.minute, from: timeOfNotifications)

        userSettings.daysBeforeNotification = Int16(daysBeforeNotifications)
        userSettings.hourOfNotification = Int16(hour)
        userSettings.minutesOfNotification = Int16(minutes)

        let userAverages = UserAverages(context: viewContext)
        userAverages.averagePeriodLength = Int16(tempPeriodLength)
        userAverages.averageCycleLength = Int16(tempCycleLength)

        let userInfos = getUserInfos()

        if var date = firstDayLastPeriod {
            date = calendar.startOfDay(for: date)
            let firstPeriodDay = PeriodDate(context: viewContext)
            firstPeriodDay.date = date

            for i in 1..<userAverages.averagePeriodLength {
                let newDate = PeriodDate(context: viewContext)
                newDate.date = date.addingDays(Int(i))
            }
        }

        userInfos.isReady = true
        saveContext(viewContext)
    }

}

enum SlideDirection {
    case left, right
}

#Preview {
    FirstTimeScreen()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .preferredColorScheme(.dark)
}
