//
//  AppIntroductionScreen.swift
//  MoonFlow
//
//  Created by Camille on 27/3/24.
//

import SwiftUI

struct AppIntroductionScreen: View {

    @Binding var currentIndex: Int
    let changeViewAction: (SlideDirection) -> Void

    @State private var opacities: [CGFloat] = [0, 0, 0, 0, 0, 0]
    @State private var offSets: [CGFloat] = [UIScreen.main.bounds.width,
                                             UIScreen.main.bounds.width,
                                             UIScreen.main.bounds.width,
                                             UIScreen.main.bounds.width,
                                             UIScreen.main.bounds.width,
                                             UIScreen.main.bounds.width]

    var body: some View {
        VStack (alignment: .leading, spacing: 18) {
            Spacer()
            SealView(title: "100% simplicity", subtitles: ["Easy to use with straightforward features"])
                .opacity(opacities[0])
                .offset(x: offSets[0])
            SealView(title: "100% secure", subtitles: ["Your data will never leave your phone or be shared"])
                .opacity(opacities[1])
                .offset(x: offSets[1])
            SealView(title: "100% free", subtitles: ["Enjoy the entirety of the app for free"])
                .opacity(opacities[2])
                .offset(x: offSets[2])
            SealView(title: "100% anonymous", subtitles: ["No account needed"])
                .opacity(opacities[3])
                .offset(x: offSets[3])
            SealView(title: "100% ad free", subtitles: ["No invasive ads"])
                .opacity(opacities[4])
                .offset(x: offSets[4])
            Spacer()
            NextButton(isDisabled: .constant(false), changeViewAction: changeViewAction)
                .opacity(opacities[5])
        }
        .onChange(of: currentIndex) { newValue in
            if newValue == 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                    for i in 0..<opacities.count {
                        let k: DispatchTime = .now() + .milliseconds(i * 600)
                        DispatchQueue.main.asyncAfter(deadline: k) {
                            withAnimation(.easeInOut) {
                                offSets[i] = 0
                                opacities[i] = 1
                            }
                        }
                    }
                }
            }
        }
        .onTapGesture {
            withAnimation(.easeInOut) {
                opacities = [1, 1, 1, 1, 1, 1]
                offSets = [0, 0, 0, 0, 0, 0]
            }
        }
    }
}

#Preview {
    AppIntroductionScreen(currentIndex: .constant(1), changeViewAction: { direction in })
        .preferredColorScheme(.dark)
}
