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
        let components = DateComponents(hour: 9, minute: 0)
        return calendar.date(from: components) ?? Date()
    }()
    @State private var arrowOffsetWelcome = CGFloat.zero
    @State private var arrowWelcomeOpacity: CGFloat = 0
    @State private var arrowNameOpacity: CGFloat = 0
    @State private var bellAngle: CGFloat = 0
    @State private var partyScale: CGFloat = 22


    @FetchRequest(sortDescriptors: [])
    private var userInfos: FetchedResults<UserInfos>

    @State private var handRotated = false
    @State private var offsetX: CGFloat = 0

    private let screenWidth = UIScreen.main.bounds.width
    private let slideDuration: CGFloat = 0.2

    var body: some View {

        HStack {
            Button {
                previousSlide()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.gray.opacity(0.5))
            }.padding(.trailing, 16)
            HStack {
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
                RoundedRectangle(cornerRadius: 5)
                    .fill(getProgressColor(.ready))
            }
            .frame(height: 5)
            .padding(.trailing, 38)
        }
        .opacity((progress == .welcome) ? 0 : 1)
        .padding(24)

        Spacer()
        ZStack {

            // --------------------------------------------------------------------------------
            // MARK: Start
            if progress == .welcome {
                VStack (spacing: 18) {
                    Spacer()
                    Text("👋")
                        .font(.system(size: 42))
                        .rotationEffect(.degrees(handRotated ? 30 : 0))
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                handRotated.toggle()
                            }
                            withAnimation(.easeInOut(duration: 0.2).delay(0.4)) {
                                handRotated.toggle()
                            }
                        }
                    Text("Hello !")
                    Button {
                        nextSlide(.name)
                    } label : {
                        VStack {
                            Text("Let's get")
                            Text("to know each other")
                            Image(systemName: "arrowshape.right.fill")
                                .offset(x: arrowOffsetWelcome, y: 0)
                                .animation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: arrowOffsetWelcome)
                                .opacity(arrowWelcomeOpacity)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        withAnimation(.easeInOut) {
                                            arrowWelcomeOpacity = 1
                                        }
                                        arrowOffsetWelcome = 10
                                    }
                                }
                                .padding(.top, 18)
                        }
                    }
                    Spacer()
                    VStack (alignment: .leading, spacing: 5) {
                        HStack (spacing: 4) {
                            Image(systemName: "checkmark.shield")
                                .font(.system(size: 16,
                                              weight: .regular))
                                .foregroundStyle(.green)
                            Text("You can trust us").bold()
                        }
                        Text("Your personal data will")+Text(" never ").bold()+Text("leave your device and will")+Text(" never ").bold()+Text("be shared with any third")
                    }
                    .font(.caption)
                    .foregroundStyle(.gray)
                }
                .offset(x: offsetX)
            }

            // --------------------------------------------------------------------------------
            // MARK: Name
            if progress == .name {
                VStack (spacing: 24) {
                    Text("🙋‍♀️")
                        .font(.system(size: 50))
                    Text("What's your name ?")
                        .multilineTextAlignment(.center)
                    TextField("", text: $name)
                        .multilineTextAlignment(.center)
                        .textInputAutocapitalization(.words)
                        .textContentType(.givenName)
                        .padding()
                        .background(.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .onSubmit {
                            if !name.isEmpty {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                nextSlide(.lastPeriod)
                                arrowNameOpacity = 1
                            }
                        }
                        .submitLabel(.next)
                    Button {
                        nextSlide(.lastPeriod)
                    } label: {
                        Image(systemName: "arrowshape.right.fill")
                    }
                    .opacity(arrowNameOpacity)
                }
                .offset(x: offsetX)
                .onAppear {
                    appearsInScreen()
                }
            }

            // --------------------------------------------------------------------------------
            // MARK: Last Period
            if progress == .lastPeriod {
                VStack (spacing: 32) {
                    Text("When was the first day of your last period ?")
                        .multilineTextAlignment(.center)
                    HStack {
                        DatePicker(
                            "",
                            selection: $tempDate,
                            in: ...Date(),
                            displayedComponents: .date
                        )
                        .labelsHidden()
                        Spacer()
                        Button {
                            firstDayLastPeriod = tempDate
                            nextSlide(.usualPeriodLength)
                        } label: {
                            Image(systemName: "arrowshape.right.fill")
                        }
                    }
                    //                    VStack {
                    Button("I don't remember") {
                        nextSlide(.usualPeriodLength)
                    }
                    .foregroundStyle(.secondary)
                    .font(.system(size: 22))
                }
                .offset(x: offsetX)
                .onAppear {
                    appearsInScreen()
                }
            }

            // --------------------------------------------------------------------------------
            // MARK: Usual Period Length
            if progress == .usualPeriodLength {
                VStack (spacing: 24) {
                    Text("What is your usual period length ?")
                        .multilineTextAlignment(.center)
                    HStack {
                        Text("\(tempPeriodLength)")
                            .font(.system(size: 38,
                                          weight: .bold,
                                          design: .rounded))
                            .foregroundStyle(.accent)
                        Text("days")
                    }
                    Stepper(
                        "",
                        value: $tempPeriodLength,
                        in: 1...20,
                        step: 1
                    )
                    .labelsHidden()
                    Button {
                        nextSlide(.usualCycleLength)
                    } label: {
                        Image(systemName: "arrowshape.right.fill")
                    }
                    Button("I don't know") {
                        nextSlide(.usualCycleLength)
                    }
                    .foregroundStyle(.secondary)
                    .font(.system(size: 22))
                    .padding(.top, 18)
                }
                .offset(x: offsetX)
                .onAppear {
                    appearsInScreen()
                }
            }

            // --------------------------------------------------------------------------------
            // MARK: Usual Cycle Length
            if progress == .usualCycleLength {
                VStack (spacing: 24) {
                    Text("What is your usual cycle length ?")
                        .multilineTextAlignment(.center)
                    HStack {
                        Text("\(tempCycleLength)")
                            .font(.system(size: 38,
                                          weight: .bold,
                                          design: .rounded))
                            .foregroundStyle(.accent)
                        Text("days")
                    }
                    Stepper(
                        "",
                        value: $tempCycleLength,
                        in: 7...40,
                        step: 1
                    )
                    .labelsHidden()
                    Button {
                        nextSlide(.notificationRequest)
                    } label: {
                        Image(systemName: "arrowshape.right.fill")
                    }
                    Button("I don't know") {
                        nextSlide(.notificationRequest)
                    }
                    .font(.system(size: 22))
                    .foregroundStyle(.secondary)
                    .padding(.top, 18)
                }
                .offset(x: offsetX)
                .onAppear {
                    appearsInScreen()
                }
            }

            // --------------------------------------------------------------------------------
            // MARK: Notifications Enabled
            if progress == .notificationRequest {
                VStack (spacing: 24) {
                    Text("Do you want to receive notifications ?")
                        .multilineTextAlignment(.center)
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
                        Image(systemName: "bell.fill")
                            .font(.system(size: 24))
                            .rotationEffect(.degrees(bellAngle))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    let duration: CGFloat = 0.3
                                    let bellAnimation = Animation.easeInOut(duration: duration)

                                    withAnimation(bellAnimation) {
                                        bellAngle = -30
                                    }
                                    withAnimation(bellAnimation.delay(duration)) {
                                        bellAngle = 0
                                    }
                                    withAnimation(bellAnimation.delay(duration*2)) {
                                        bellAngle = -30
                                    }
                                    withAnimation(bellAnimation.delay(duration*3)) {
                                        bellAngle = 0
                                    }
                                    Timer.scheduledTimer(withTimeInterval: duration*4+1.5, repeats: true) { timer in
                                        withAnimation(bellAnimation) {
                                            bellAngle = -30
                                        }
                                        withAnimation(bellAnimation.delay(duration)) {
                                            bellAngle = 0
                                        }
                                        withAnimation(bellAnimation.delay(duration*2)) {
                                            bellAngle = -30
                                        }
                                        withAnimation(bellAnimation.delay(duration*3)) {
                                            bellAngle = 0
                                        }
                                    }
                                }
                            }

                        Text("Yes")
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 12)
                    .background(.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 32)
                    Button("No") {
                        nextSlide(.ready)
                    }
                    .font(.system(size: 22))
                    .foregroundStyle(.secondary)
                }
                .offset(x: offsetX)
                .onAppear {
                    appearsInScreen()
                }
            }

            // --------------------------------------------------------------------------------
            // MARK: Notifications Setup
            if progress == .notificationSetup {
                VStack (spacing: 24) {
                    Text("When do you want to be notified about your next periods ?")
                        .multilineTextAlignment(.center)
                    HStack{
                        Text("\(daysBeforeNotifications)")
                            .foregroundStyle(.accent)
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                        Text("day(s) before")
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
                    .padding(.top, 22)
                    HStack{
                        Text("At")
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
                        Image(systemName: "arrowshape.right.fill")
                    }
                    .padding(.top, 28)
                }
                .offset(x: offsetX)
                .onAppear {
                    appearsInScreen()
                }
            }

            // --------------------------------------------------------------------------------
            // MARK: Ready
            if progress == .ready {
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
                    Text("We're ready \(name) !")
                        .multilineTextAlignment(.center)
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
                .offset(x: offsetX)
                .onAppear {
                    appearsInScreen()
                }
            }
            Spacer()
        }
        .font(.system(.title, design: .rounded))
        .padding(24)
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

    private func previousSlide() {
        withAnimation {
            offsetX = screenWidth*2
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + slideDuration) {
            switch progress {
            case .name: progress = .welcome
            case .lastPeriod: progress = .name
            case .usualPeriodLength: progress = .lastPeriod
            case .usualCycleLength: progress = .usualPeriodLength
            case .notificationRequest: progress = .usualCycleLength
            case .notificationSetup: progress = .notificationRequest
            case .ready: progress = .notificationSetup
            default: break
            }
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

#Preview {
    FirstTimeScreen()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
