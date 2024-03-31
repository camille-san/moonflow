//
//  BackgroundTest.swift
//  MoonFlow
//
//  Created by Camille on 27/3/24.
//

import SwiftUI

struct BackgroundTest: View {
    var body: some View {
        VStack {
            Circle().fill(.white)
        }
        .background(.BGCOLOR)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    BackgroundTest()
}
