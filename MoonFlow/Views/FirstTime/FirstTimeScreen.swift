//
//  FirstTimeScreen.swift
//  MoonFlow
//
//  Created by Camille on 22/3/24.
//

import SwiftUI

struct FirstTimeScreen: View {

    enum Step {
        case welcome
        case name
        case lastPeriod
        case usualPeriodLength
        case usualCycleLength
        case notificationRequest
        case notificationSetup
        case ready
    }

    @Environment(\.managedObjectContext) private var viewContext

    @State private var progress: Step = .welcome
    @State private var name = ""
    @State private var firstDayLastPeriod: Date?
    @State private var tempDate: Date = Date()
    @State private var tempPeriodLength: Int = 7
    @State private var tempCycleLength: Int = 28
    @State private var areNotificationsEnabled = false
    @State private var daysBeforeNotifications = 1
    @State private var timeOfNotifications: Date = {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let components = DateComponents(hour: 9, minute: 0)
        return calendar.date(from: components) ?? Date()
    }()

    @FetchRequest(sortDescriptors: [])
    private var userInfos: FetchedResults<UserInfos>

    @State private var handRotated = false
    @State private var offsetX: CGFloat = 0

    private let screenWidth = UIScreen.main.bounds.width
    private let slideDuration: CGFloat = 0.2

    var body: some View {

        HStack {
            Group {
                RoundedRectangle(cornerRadius: 5)
                    .fill(getProgressColor(.welcome))
                RoundedRectangle(cornerRadius: 5)
                    .fill(getProgressColor(.name))
                RoundedRectangle(cornerRadius: 5)
                    .fill(getProgressColor(.lastPeriod))
                RoundedRectangle(cornerRadius: 5)
                    .fill(getProgressColor(.usualPeriodLength))
                RoundedRectangle(cornerRadius: 5)
                    .fill(getProgressColor(.usualCycleLength))
                RoundedRectangle(cornerRadius: 5)
                    .fill(getProgressColor(.notificationRequest))
                RoundedRectangle(cornerRadius: 5)
                    .fill(getProgressColor(.notificationSetup))
            }
            .frame(height: 5)
        }
        .opacity((progress == .welcome || progress == .ready) ? 0 : 100)
        .padding(.top, 24)
        .padding(.horizontal, 58)

        Spacer()
        ZStack {

            // MARK: Start
            if progress == .welcome {
                VStack (spacing: 18) {
                    Text("👋")
                        .font(.system(size: 42))
                        .rotationEffect(.degrees(handRotated ? 30 : 0))
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                handRotated.toggle()
                            }
                            withAnimation(.easeInOut(duration: 0.2).delay(1)) {
                                handRotated.toggle()
                            }
                        }
                    Text("Hello !")
                        .font(.system(size: 28))
                    Button {
                        nextSlide(.name)
                    } label : {
                        VStack {
                            Group {
                                Text("Let's get")
                                Text("to know each other")
                            }
                            .font(.system(size: 28,
                                          weight: .medium,
                                          design: .rounded))
                        }
                    }
                }
                .offset(x: offsetX)
            }

            // MARK: Name
            if progress == .name {
                VStack (spacing: 24) {
                    Text("What's your name ?")
                        .multilineTextAlignment(.center)
                        .font(.title)
                    TextField("", text: $name)
                        .multilineTextAlignment(.center)
                        .textInputAutocapitalization(.words)
                        .textContentType(.givenName)
                        .padding()
                        .background(.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .font(.title)
                        .onSubmit {
                            nextSlide(.lastPeriod)
                        }
                    Button {
                        nextSlide(.lastPeriod)
                    } label: {
                        Text("Next")
                            .foregroundStyle(.white)
                            .font(.system(size: 22))
                            .padding(.horizontal, 18)
                            .padding(.vertical, 12)
                            .background(.accent)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .opacity(name.isEmpty ? 0 : 100)
                    .padding(.top, 52)
                }
                .offset(x: offsetX)
                .onAppear {
                    appearsInScreen()
                }
            }

            // MARK: Last Period
            if progress == .lastPeriod {
                VStack (spacing: 24) {
                    Text("When was the first day of your last period ?")
                        .multilineTextAlignment(.center)
                        .font(.title)
                    DatePicker(
                        "",
                        selection: $tempDate,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    VStack {
                        Button {
                            firstDayLastPeriod = tempDate
                            nextSlide(.usualPeriodLength)
                        } label: {
                            Text("Next")
                                .foregroundStyle(.white)
                                .font(.system(size: 22))
                                .padding(.horizontal, 18)
                                .padding(.vertical, 12)
                                .background(.accent)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        Button("I don't remember") {
                            nextSlide(.usualPeriodLength)
                        }
                        .foregroundStyle(.secondary)
                        Button("Previous") {
                            previousSlide(.name)
                        }
                        .foregroundStyle(.secondary)
                    }
                    .padding(.top, 52)
                }
                .offset(x: offsetX)
                .onAppear {
                    appearsInScreen()
                }
            }

            // MARK: Usual Period Length
            if progress == .usualPeriodLength {
                VStack (spacing: 24) {
                    Text("What is your usual period length ?")
                        .multilineTextAlignment(.center)
                        .font(.title)
                    Text("\(tempPeriodLength)")
                        .font(.system(size: 38,
                                      weight: .bold,
                                      design: .rounded))
                        .foregroundStyle(.accent)
                    Text("days")
                    Stepper(
                        "",
                        value: $tempPeriodLength,
                        in: 1...20,
                        step: 1
                    )
                    .labelsHidden()
                    VStack {
                        Button {
                            nextSlide(.usualCycleLength)
                        } label: {
                            Text("Next")
                                .foregroundStyle(.white)
                                .font(.system(size: 22))
                                .padding(.horizontal, 18)
                                .padding(.vertical, 12)
                                .background(.accent)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        Button("I don't know") {
                            nextSlide(.usualCycleLength)
                        }
                        .foregroundStyle(.secondary)
                        Button("Previous") {
                            previousSlide(.lastPeriod)
                        }
                        .foregroundStyle(.secondary)
                    }
                    .padding(.top, 52)
                }
                .offset(x: offsetX)
                .onAppear {
                    appearsInScreen()
                }
            }

            // MARK: Usual Cycle Length
            if progress == .usualCycleLength {
                VStack (spacing: 24) {
                    Text("What is your usual cycle length ?")
                        .multilineTextAlignment(.center)
                        .font(.title)
                    Text("\(tempCycleLength)")
                        .font(.system(size: 38,
                                      weight: .bold,
                                      design: .rounded))
                        .foregroundStyle(.accent)
                    Text("days")
                    Stepper(
                        "",
                        value: $tempCycleLength,
                        in: 7...40,
                        step: 1
                    )
                    .labelsHidden()
                    VStack {
                        Button {
                            nextSlide(.notificationRequest)
                        } label: {
                            Text("Next")
                                .foregroundStyle(.white)
                                .font(.system(size: 22))
                                .padding(.horizontal, 18)
                                .padding(.vertical, 12)
                                .background(.accent)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        Button("I don't know") {
                            nextSlide(.notificationRequest)
                        }
                        .foregroundStyle(.secondary)
                        Button("Previous") {
                            previousSlide(.usualPeriodLength)
                        }
                        .foregroundStyle(.secondary)
                    }
                    .padding(.top, 52)
                }
                .offset(x: offsetX)
                .onAppear {
                    appearsInScreen()
                }
            }

            // MARK: Notifications Enabled
            if progress == .notificationRequest {
                VStack (spacing: 24) {
                    Text("Do you want to receive notifications ?")
                        .multilineTextAlignment(.center)
                        .font(.title)
                    Button {
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                            if success {
                                areNotificationsEnabled = true
                                nextSlide(.notificationSetup)
                            } else {
                                nextSlide(.ready)
                            }
                        }
                    } label: {
                        Text("Yes")
                            .foregroundStyle(.white)
                            .font(.system(size: 22))
                            .padding(.horizontal, 18)
                            .padding(.vertical, 12)
                            .background(.accent)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.top, 52)
                    Button("No") {
                        nextSlide(.ready)
                    }
                }
                .offset(x: offsetX)
                .onAppear {
                    appearsInScreen()
                }
            }

            // MARK: Notifications Setup
            if progress == .notificationSetup {
                VStack (spacing: 24) {
                    Text("When do you want to be notified about your next periods ?")
                        .multilineTextAlignment(.center)
                        .font(.title)
                    HStack{
                        Group {
                            Text("\(daysBeforeNotifications)")
                                .foregroundStyle(.accent)
                            Text("day(s) before")
                        }
                        .font(.system(size: 18))
                        Spacer()
                        Stepper(
                            "",
                            value: $daysBeforeNotifications,
                            in: 0...4,
                            step: 1
                        )
                        .labelsHidden()
                    }
                    HStack{
                        Group {
                            Text("Time of notification")
                        }
                        .font(.system(size: 18))
                        Spacer()
                        DatePicker(
                            "Start Date",
                            selection: $timeOfNotifications,
                            displayedComponents: [.hourAndMinute]
                        )
                        .labelsHidden()
                    }
                    Button {
                        nextSlide(.ready)
                    } label: {
                        Text("Next")
                            .foregroundStyle(.white)
                            .font(.system(size: 22))
                            .padding(.horizontal, 18)
                            .padding(.vertical, 12)
                            .background(.accent)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.top, 52)
                    Button("Previous") {
                        previousSlide(.notificationRequest)
                    }
                    .foregroundStyle(.secondary)
                }
                .offset(x: offsetX)
                .onAppear {
                    appearsInScreen()
                }
            }

            // MARK: Ready
            if progress == .ready {
                VStack (spacing: 24) {
                    Text("🎉")
                        .font(.system(size: 42))
                    Text("We're ready \(name) !")
                        .multilineTextAlignment(.center)
                        .font(.title)
                    Button {
                        makeReady()
                    } label: {
                        Text("Let's start")
                            .foregroundStyle(.white)
                            .font(.system(size: 22))
                            .padding(.horizontal, 18)
                            .padding(.vertical, 12)
                            .background(.accent)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .offset(x: offsetX)
                .onAppear {
                    appearsInScreen()
                }
            }
            Spacer()
        }
        .padding(.horizontal, 58)
        Spacer()
    }

    private func getProgressColor(_ step: Step) -> Color {
        if progress == step {
            return .accentColor
        } else {
            return .gray.opacity(0.3)
        }
    }

    private func getUserInfos() -> UserInfos {
        if let infos: UserInfos = userInfos.first {
            return infos
        } else {
            fatalError("Initialization of database error")
        }
    }

    private func nextSlide(_ step: Step) {
        withAnimation {
            offsetX = -screenWidth
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + slideDuration) {
            progress = step
            offsetX = screenWidth
            appearsInScreen()
        }
    }

    private func previousSlide(_ step: Step) {
        withAnimation {
            offsetX = screenWidth*2
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + slideDuration) {
            progress = step
            offsetX = -screenWidth
            appearsInScreen()
        }
    }

    private func appearsInScreen() {
        withAnimation {
            offsetX = 0
        }
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
        userInfos.name = name

        if let date = firstDayLastPeriod {
            let firstPeriodDay = PeriodDate(context: viewContext)
            firstPeriodDay.date = date

            for i in 1..<userAverages.averagePeriodLength {
                let newDate = PeriodDate(context: viewContext)
                newDate.date = date.addingDays(Int(i))
            }
        }

        userInfos.isReady = true
        saveContext()
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
    FirstTimeScreen()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
