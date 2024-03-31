//
//  PeriodLengthScreen.swift
//  MoonFlow
//
//  Created by Camille on 27/3/24.
//

import SwiftUI

struct PeriodLengthScreen: View {
    
    let changeViewAction: (SlideDirection) -> Void
    
    @Binding var periodLength: Int
    
    private let options: [Int] = Array(2...15)
    
    var body: some View {
        VStack (spacing: 18) {
            Spacer()
            VStack {
                Text("What is your usual")
                HStack (spacing: 9) {
                    Text("period")
                        .foregroundStyle(.red)
                    Image(systemName: "drop.fill")
                        .foregroundStyle(.red)
                        .font(.system(size: 24))
                    Text("length ?")
                }
            }
            .font(.system(size: 28, weight: .bold, design: .rounded))
            .multilineTextAlignment(.center)
            .foregroundStyle(.accent)
            VStack {
                Text("We need this information in order to predict")
                Text("This information will adapt as your record your periods")
            }
            .foregroundStyle(.secondary)
            .font(.system(.body, design: .rounded))
            Spacer()
            HStack {
                Picker(selection: $periodLength, label: Text("Select Option")) {
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
            Button("I don't know") {
                changeViewAction(.right)
            }
            .foregroundStyle(.secondary)
            .font(.system(size: 22, design: .rounded))
            .padding(.top, 18)
            NextButton(isDisabled: .constant(false), changeViewAction: changeViewAction)
        }
    }
}

#Preview {
    PeriodLengthScreen(changeViewAction: { direction in }, periodLength: .constant(7))
        .preferredColorScheme(.dark)
}
