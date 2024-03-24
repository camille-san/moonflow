//
//  SettingsScreen.swift
//  MoonFlow
//
//  Created by Camille on 21/3/24.
//

import SwiftUI

struct SettingsScreen: View {

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [])
    private var userInfos: FetchedResults<UserInfos>
    @FetchRequest(sortDescriptors: [])
    private var periods: FetchedResults<PeriodDate>
    @FetchRequest(sortDescriptors: [])
    private var averages: FetchedResults<UserAverages>
    @FetchRequest(sortDescriptors: [])
    private var settings: FetchedResults<UserSettings>

    var body: some View {
        VStack {
            Color.gray.opacity(0.3)
                .clipShape(
                    RoundedRectangle(cornerRadius: 32))
                .frame(width: 70, height: 5)
                .padding(.top, 24)
            Text("Settings")
                .font(.title)
                .bold()
            Button("Back start") {
                userInfos.first!.isReady = false

                for period in periods {
                    viewContext.delete(period)
                }

                viewContext.delete(averages.first!)
                viewContext.delete(settings.first!)

                do {
                    try self.viewContext.save()
                } catch {
                    print("Failed to save context: \(error)")
                }
            }
            Spacer()
        }
    }
    
}

#Preview {
    SettingsScreen()
}
