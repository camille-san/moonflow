//
//  CycleLengthScreen.swift
//  MoonFlow
//
//  Created by Camille on 27/3/24.
//

import SwiftUI

struct CycleLengthScreen: View {

    let changeViewAction: (SlideDirection) -> Void

    @Binding var cycleLength: Int

    private let options: [Int] = Array(10...60)

    var body: some View {
        VStack (spacing: 32) {
            Spacer()
            VStack {
                Text("What is your usual")
                HStack (spacing: 9) {
                    Text("cycle")
                        .foregroundStyle(.white)
                    Image(systemName: "moon.fill")
                        .foregroundStyle(.white)
                        .font(.system(size: 24))
                    Text("length ?")
                }
            }
            .font(.system(size: 28, weight: .bold, design: .rounded))
            .multilineTextAlignment(.center)
            .foregroundStyle(.accent)
            Spacer()
            HStack {
                Picker(selection: $cycleLength, label: Text("Select Option")) {
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
            .font(.system(size: 22))
            .foregroundStyle(.secondary)
            .padding(.top, 18)
            NextButton(isDisabled: .constant(false), changeViewAction: changeViewAction)
        }
    }
}

#Preview {
    CycleLengthScreen(changeViewAction: { direction in }, cycleLength: .constant(28))
        .preferredColorScheme(.dark)
}
