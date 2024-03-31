//
//  LastPeriodScreen.swift
//  MoonFlow
//
//  Created by Camille on 27/3/24.
//

import SwiftUI

struct LastPeriodScreen: View {

    let changeViewAction: (SlideDirection) -> Void

    @Binding var firstDayLastPeriod: Date?

    @State private var tempDate = Date()
    @State private var isDateEmpty = true
    @State private var arrowOffsetLastPeriod = CGFloat.zero

    var body: some View {
        VStack (spacing: 18) {

            Spacer()
            VStack {
                Text("When was the first day")
                HStack (spacing: 9) {
                    Text("of your last")
                    Text("period")
                        .foregroundStyle(.red)
                    Image(systemName: "drop.fill")
                        .foregroundStyle(.red)
                        .font(.system(size: 24))
                    Text("?")
                }
            }
            .font(.system(.title, design: .rounded))
            .bold()
            .multilineTextAlignment(.center)
            .foregroundStyle(.accent)
            Spacer()
            DatePicker("", selection: $tempDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .onChange(of: tempDate) { newValue in
                    firstDayLastPeriod = tempDate
                    isDateEmpty = false
                }
                .labelsHidden()
                .padding()
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            Spacer()
            Button("I don't remember") {
                changeViewAction(.right)
            }
            .foregroundStyle(.secondary)
            .font(.system(size: 22, design: .rounded))
            NextButton(isDisabled: $isDateEmpty, changeViewAction: changeViewAction)
        }
    }
}

#Preview {
    LastPeriodScreen(changeViewAction: { direction in }, firstDayLastPeriod: .constant(nil))
        .preferredColorScheme(.dark)
}
