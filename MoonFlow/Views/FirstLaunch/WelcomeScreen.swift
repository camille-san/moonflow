//
//  WelcomeScreen.swift
//  MoonFlow
//
//  Created by Camille on 27/3/24.
//

import SwiftUI

struct WelcomeScreen: View {

    private let animationDelayPerItem: Double = 0.6
    private let initialAnimationDuration: Double = 1.1

    let changeViewAction: (SlideDirection) -> Void

    @State private var dropOffset: CGFloat = -60
    @State private var dropOpacity: CGFloat = 0
    @State private var opacities: [CGFloat] = [0, 0, 0, 0, 0]

    var body: some View {
        VStack (spacing: 18) {
            HStack {
                Text("MoonFlow")
                    .foregroundStyle(.accent)
                    .bold()
                Image(systemName: "drop.fill")
                    .foregroundStyle(.red)
                    .offset(y: dropOffset)
                    .opacity(dropOpacity)
            }
            .font(.system(.largeTitle, design: .rounded))
            Image("5fullmoon_A")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: 125, maxHeight: 125)
                .padding(.top, 32)
                .accessibilityLabel("A cute smiling full moon")
            Spacer()
            Text("Track & predict your cycle")
                .font(.system(.title2, design: .rounded))
                .opacity(opacities[0])
                .padding(.bottom, 18)
            VStack (alignment: .trailing, spacing: 18) {
                HStack (spacing: 18) {
                    Text("menstruation")
                        .foregroundStyle(.red)
                    Image(systemName: "moon.fill")
                }
                .opacity(opacities[1])

                HStack (spacing: 18) {
                    Text("ovulation")
                        .foregroundStyle(.mint)
                    Image(systemName: "medical.thermometer.fill")
                }
                .opacity(opacities[2])
                HStack (spacing: 18) {
                    Text("contraception")
                        .foregroundStyle(.cyan)
                    Image(systemName: "pills.fill")
                }
                .opacity(opacities[3])
            }
            .font(.system(.title, design: .rounded))
            .bold()
            Spacer()
            NextButton(isDisabled: .constant(false), changeViewAction: changeViewAction)
                .opacity(opacities[4])
        }
        .onAppear {
            animateDrop()
            animateOpacitiesSequentially()
        }
    }

    private func animateDrop() {
        withAnimation(.easeInOut(duration: initialAnimationDuration)) {
            dropOpacity = 1
            dropOffset = 0
        }
    }

    private func animateOpacitiesSequentially() {
        for index in opacities.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + initialAnimationDuration + Double(index) * animationDelayPerItem) {
                withAnimation(.easeInOut) {
                    opacities[index] = 1
                }
            }
        }
    }

}

#Preview {
    WelcomeScreen(changeViewAction: { direction in })
        .preferredColorScheme(.dark)
}
