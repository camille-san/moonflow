//
//  ContentView.swift
//  MoonFlow
//
//  Created by Camille on 21/3/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State private var selection: Tab = .calendar
    @State private var showSettings = false

    enum Tab {
        case calendar
        case user
    }

    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                MonthCalendarScreen()
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")
                    }
                    .tag(Tab.calendar)
                UserInfosScreen()
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
    }
}

#Preview {
    ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
