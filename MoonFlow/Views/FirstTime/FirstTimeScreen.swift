//
//  FirstTimeScreen.swift
//  MoonFlow
//
//  Created by Camille on 22/3/24.
//

import SwiftUI

struct FirstTimeScreen: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [])
    private var userInfos: FetchedResults<UserInfos>

    var body: some View {
        Text("Welcome !")
        Button("Yes I'm ready !") {
            makeReady()
        }
    }

    private func getUserInfos() -> UserInfos {
        if let infos: UserInfos = userInfos.first {
            return infos
        } else {
            fatalError("hello")
        }
    }

    private func makeReady() {
        getUserInfos().isReady = true
saveContext()
    }

    private func saveContext() {
        do {
            try self.viewContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }

}

#Preview {
    FirstTimeScreen()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
