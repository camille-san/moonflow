//
//  LocationSetupScreen.swift
//  MoonFlow
//
//  Created by Camille on 27/3/24.
//

import SwiftUI

struct LocationSetupScreen: View {

    let changeViewAction: (SlideDirection) -> Void

    @StateObject private var locationManager = LocationManager()

    var body: some View {
        VStack {
            if let location = locationManager.location {
                Text("Latitude: \(location.latitude), Longitude: \(location.longitude)")
            } else {
                Text("Location data not available.")
            }
            Button("next") {
                changeViewAction(.right)
            }
        }
        .onAppear {
            locationManager.requestPermission()
        }
    }
}

#Preview {
    LocationSetupScreen(changeViewAction: { direction in })
        .preferredColorScheme(.dark)
}
