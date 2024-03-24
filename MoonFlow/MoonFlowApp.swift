//
//  MoonFlowApp.swift
//  MoonFlow
//
//  Created by Camille on 21/3/24.
//

import SwiftUI

@main
struct MoonFlowApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(.light)
                .font(.system(.body, design: .rounded))
        }
    }
    
}
