//
//  SealView.swift
//  MoonFlow
//
//  Created by Camille on 28/3/24.
//

import SwiftUI

struct SealView: View {

    let title: String
    let subtitles: [String]

    var body: some View {
        HStack (alignment: .top, spacing: 20) {
            Image(systemName: "checkmark.seal.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.green, .white.opacity(0.2))
                .font(.system(.title, design: .rounded))
            VStack (alignment: .leading) {
                Text(title)
                    .font(.system(.title, design: .rounded))
                    .bold()
                ForEach(subtitles, id: \.self) { subtitle in
                    Text(subtitle).foregroundStyle(.secondary)
                        .font(.system(.title2, design: .rounded))
                }
            }
        }
    }

}

#Preview {
    SealView(title: "title", subtitles: ["subtitle1", "subtitle2"])
        .preferredColorScheme(.dark)
}
