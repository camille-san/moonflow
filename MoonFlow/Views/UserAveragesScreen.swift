//
//  UserInfosScreen.swift
//  MoonFlow
//
//  Created by Camille on 21/3/24.
//

import SwiftUI
import CoreData

struct UserAveragesScreen: View {

    @Environment(\.managedObjectContext) var viewContext

    //    @FetchRequest(
    //        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    //        animation: .default)
    @FetchRequest(sortDescriptors: [])
    private var userAverages: FetchedResults<UserAverages>

    var body: some View {
VStack {
                Text("Health informations")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 24)
                HStack {
                    Text("Average Cycle Length")
                    Text("\(userAverages[0].averageCycleLength)")
                        .foregroundStyle(Color.accentColor)
                        .bold()
                }
                HStack {
                    Text("Average Period Length")
                    Text("\(userAverages[0].averagePeriodLength)")
                        .foregroundStyle(Color.accentColor)
                        .bold()
                }
                Spacer()
            }
    }
}

#Preview {
    UserAveragesScreen()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
