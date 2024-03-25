//
//  DataManager.swift
//  MoonFlow
//
//  Created by Camille on 25/3/24.
//

import Foundation
import CoreData

class DataManager: ObservableObject {

    @Published var userInfos: UserInfos?
    @Published var userAverages: UserAverages?

    private var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchUserInfos()
        fetchUserAverages()
    }

    func fetchUserInfos() {
        let request: NSFetchRequest<UserInfos> = UserInfos.fetchRequest()
        request.sortDescriptors = []

        do {
            let userInfosList: [UserInfos] = try viewContext.fetch(request)
            userInfos = userInfosList.first
        } catch {
            print("Error fetching data: \(error)")
        }
    }

    func fetchUserAverages() {
        let request: NSFetchRequest<UserAverages> = UserAverages.fetchRequest()
        request.sortDescriptors = []

        do {
            let userAveragesList: [UserAverages] = try viewContext.fetch(request)
            userAverages = userAveragesList.first
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}
