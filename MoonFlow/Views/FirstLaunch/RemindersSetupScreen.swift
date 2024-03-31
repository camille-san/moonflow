//
//  RemindersSetupScreen.swift
//  MoonFlow
//
//  Created by Camille on 27/3/24.
//

import SwiftUI

struct RemindersSetupScreen: View {

    let changeViewAction: (SlideDirection) -> Void

    @Binding var areNotificationsEnabled: Bool
    @Binding var reminderDaysBeforePeriod: Int
    @Binding var hourOfPeriodReminder: Int
    @Binding var minutesOfPeriodReminder: Int

    @State private var bellAngle: CGFloat = 0

    private let options: [Int] = Array(0...7)
    private let hours: [Int] = Array(0...23)
    private let minutes: [Int] = Array(10...60)

    var body: some View {
        VStack (spacing: 18) {
            Spacer()
            VStack {
                Text("Do you want")
                HStack (spacing: 9) {
                    Text("a")
                    Text("reminder")
                        .foregroundStyle(.white)
                    Image(systemName: "bell.fill")
                        .foregroundStyle(.white)
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
                    Text("?")
                }
            }
            .font(.system(size: 28, weight: .bold, design: .rounded))
            .multilineTextAlignment(.center)
            .foregroundStyle(.accent)
            Text("Choose when do you want to receive a reminder about your next incoming period")
                .multilineTextAlignment(.center)
            Spacer()
            HStack {
                Picker(selection: $reminderDaysBeforePeriod, label: Text("Select Option")) {
                    ForEach(options, id: \.self) { option in
                        Text("\(option)")
                            .font(.system(size: 32))
                            .tag(option)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 125, height: 125)
                Text("days")
            }
            Spacer()
            Text("Choose when do you want to receive a reminder about your next incoming period")
                .multilineTextAlignment(.center)
            Button {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        areNotificationsEnabled = true
                    }
                }
                changeViewAction(.right)
            } label: {
                HStack {
                    Spacer()
                    Text("Next")
                    Spacer()
                }
                .font(.system(size: 24,
                              weight: .medium,
                              design: .rounded))
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(.accent)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

#Preview {
    RemindersSetupScreen(
        changeViewAction: { direction in },
        areNotificationsEnabled: .constant(true),
        reminderDaysBeforePeriod: .constant(2),
        hourOfPeriodReminder: .constant(9),
        minutesOfPeriodReminder: .constant(15))
    .preferredColorScheme(.dark)
}
