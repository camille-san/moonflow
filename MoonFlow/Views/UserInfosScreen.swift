//
//  UserInfosScreen.swift
//  MoonFlow
//
//  Created by Camille on 21/3/24.
//

import SwiftUI
import CoreData

struct UserInfosScreen: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    //    @FetchRequest(
    //        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    //        animation: .default)
    @FetchRequest(sortDescriptors: [])
    private var userInfos: FetchedResults<UserInfos>
    
    var body: some View {
        VStack {
            HStack {
                Text("Average Cycle Length")
                Text("\(userInfos[0].averageCycleLength)")
                    .bold()
            }
            HStack {
                Text("Average Period Length")
                Text("\(userInfos[0].averagePeriodLength)")
                    .bold()
            }
        }
    }
}

#Preview {
    UserInfosScreen()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
