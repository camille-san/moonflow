//
//  Persistence.swift
//  MoonFlow
//
//  Created by Camille on 21/3/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        let dateFormatter = getDateFormatter()

        let date1 = PeriodDate(context: viewContext)
        date1.date = dateFormatter.date(from: "30/10/2023")!

        let date2 = PeriodDate(context: viewContext)
        date2.date = dateFormatter.date(from: "31/10/2023")!

        let date3 = PeriodDate(context: viewContext)
        date3.date = dateFormatter.date(from: "01/11/2023")!

        let date4 = PeriodDate(context: viewContext)
        date4.date = dateFormatter.date(from: "02/11/2023")!

        let date5 = PeriodDate(context: viewContext)
        date5.date = dateFormatter.date(from: "03/11/2023")!

        // =============================

        let date6 = PeriodDate(context: viewContext)
        date6.date = dateFormatter.date(from: "25/11/2023")!

        let date7 = PeriodDate(context: viewContext)
        date7.date = dateFormatter.date(from: "26/11/2023")!

        let date8 = PeriodDate(context: viewContext)
        date8.date = dateFormatter.date(from: "27/11/2023")!

        let date9 = PeriodDate(context: viewContext)
        date9.date = dateFormatter.date(from: "28/11/2023")!

        let date10 = PeriodDate(context: viewContext)
        date10.date = dateFormatter.date(from: "29/11/2023")!

        // =============================

        let date11 = PeriodDate(context: viewContext)
        date11.date = dateFormatter.date(from: "21/12/2023")!

        let date12 = PeriodDate(context: viewContext)
        date12.date = dateFormatter.date(from: "22/12/2023")!

        let date13 = PeriodDate(context: viewContext)
        date13.date = dateFormatter.date(from: "23/12/2023")!

        let date14 = PeriodDate(context: viewContext)
        date14.date = dateFormatter.date(from: "24/12/2023")!

        // =============================

        let date15 = PeriodDate(context: viewContext)
        date15.date = dateFormatter.date(from: "18/01/2024")!

        let date16 = PeriodDate(context: viewContext)
        date16.date = dateFormatter.date(from: "19/01/2024")!

        let date17 = PeriodDate(context: viewContext)
        date17.date = dateFormatter.date(from: "20/01/2024")!

        let date18 = PeriodDate(context: viewContext)
        date18.date = dateFormatter.date(from: "21/01/2024")!

        let date19 = PeriodDate(context: viewContext)
        date19.date = dateFormatter.date(from: "22/01/2024")!

        // =============================

        let date20 = PeriodDate(context: viewContext)
        date20.date = dateFormatter.date(from: "14/02/2024")!

        let date21 = PeriodDate(context: viewContext)
        date21.date = dateFormatter.date(from: "15/02/2024")!

        let date22 = PeriodDate(context: viewContext)
        date22.date = dateFormatter.date(from: "16/02/2024")!

        let date23 = PeriodDate(context: viewContext)
        date23.date = dateFormatter.date(from: "17/02/2024")!

        let date24 = PeriodDate(context: viewContext)
        date24.date = dateFormatter.date(from: "18/02/2024")!

        let date25 = PeriodDate(context: viewContext)
        date25.date = dateFormatter.date(from: "19/02/2024")!

        let userAverages = UserAverages(context: viewContext)
        userAverages.averageCycleLength = 27
        userAverages.averagePeriodLength = 5

        let userSettings = UserSettings(context: viewContext)

        let userInfos = UserInfos(context: viewContext)
        userInfos.name = "Camille"

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MoonFlow")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true

        if isFirstLaunch() {
            populateInitialData(context: container.viewContext)
        }
    }

    private func isFirstLaunch() -> Bool {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        if !hasLaunchedBefore {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }

    private func populateInitialData(context: NSManagedObjectContext) {
        let userAverages = UserAverages(context: context)
        userAverages.averageCycleLength = 28
        userAverages.averagePeriodLength = 7

        let userSettings = UserSettings(context: context)

        let userInfos = UserInfos(context: context)
        userInfos.isReady = false

        saveContext(context: context)
    }

    private func saveContext(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

}
