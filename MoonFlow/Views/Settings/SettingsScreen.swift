//
//  SettingsScreen.swift
//  MoonFlow
//
//  Created by Camille on 21/3/24.
//

import SwiftUI

struct SettingsScreen: View {
    
    var body: some View {
        VStack {
            Color.gray.opacity(0.3)
                .clipShape(
                    RoundedRectangle(cornerRadius: 32))
                .frame(width: 70, height: 8)
                .padding(.top, 24)
            Text("Settings")
                .font(.title)
                .bold()
            Spacer()
        }
    }
    
}

#Preview {
    SettingsScreen()
}
