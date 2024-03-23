//
//  ContentView.swift
//  MoonFlow
//
//  Created by Camille on 21/3/24.
//

import SwiftUI
import CoreData
import UserNotifications

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var selection: Tab = .calendar
    @State private var showSettings = false
    
    @FetchRequest(sortDescriptors: [])
    private var userInfos: FetchedResults<UserInfos>
    
    enum Tab {
        case calendar
        case user
    }
    
    var body: some View {
        if getUserInfos().isReady {
            NavigationView {
                TabView(selection: $selection) {
                    MonthCalendarScreen()
                        .tabItem {
                            Label("Calendar", systemImage: "calendar")
                        }
                        .tag(Tab.calendar)
                    UserAveragesScreen()
                        .tabItem {
                            Label("Statistics", systemImage: "chart.xyaxis.line")
                        }
                        .tag(Tab.user)
                }
                .preferredColorScheme(.light)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showSettings.toggle()
                        } label : {
                            Image(systemName: "gearshape")
                        }
                    }
                }
                .sheet(isPresented: $showSettings) {
                    SettingsScreen()
                }
            }
        } else {
            FirstTimeScreen()
        }
    }
    
    private func getUserInfos() -> UserInfos {
        if let infos: UserInfos = userInfos.first {
            return infos
        } else {
            fatalError("Initialization of database error")
        }
    }
    
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
