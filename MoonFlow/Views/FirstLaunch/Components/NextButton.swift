//
//  NextButton.swift
//  MoonFlow
//
//  Created by Camille on 28/3/24.
//

import SwiftUI

struct NextButton: View {
    
    @Binding var isDisabled: Bool
    let changeViewAction: (SlideDirection) -> Void
    
    var body: some View {
        
        Button {
            if !isDisabled {
                changeViewAction(.right)
            }
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
            .background(.accent.opacity(isDisabled ? 0.3 : 1))
            .foregroundStyle(.white.opacity(isDisabled ? 0.5 : 1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    NextButton(isDisabled: .constant(true), changeViewAction: {direction in})
}
