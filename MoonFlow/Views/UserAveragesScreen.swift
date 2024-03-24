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

    private let size: CGFloat = 45

    var body: some View {
        VStack {
            Text("Your informations")
                .font(.title)
                .bold()
                .padding(.bottom, 24)
            HStack (alignment: .top) {
                VStack {
                    Text("\(userAverages[0].averageCycleLength)")
                        .foregroundStyle(.black)
                        .bold()
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(lineWidth: 2.5).fill(.accent))
                    Text("Average Cycle Length")
                        .multilineTextAlignment(.center)
                }
                Spacer()
                VStack {
                    Text("\(userAverages[0].averagePeriodLength)")
                        .foregroundStyle(.black)
                        .bold()
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(lineWidth: 2.5).fill(.accent))
                    Text("Average Period Length")
                        .multilineTextAlignment(.center)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 58)
    }
}

#Preview {
    UserAveragesScreen()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
