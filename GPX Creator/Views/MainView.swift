//
//  ContentView.swift
//  GPX Creator
//
//  Created by Maciej Gulda on 26/09/2023.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @State var mapViewModel: MapViewModel
        
    var body: some View {
        VStack {
            MapView(mapViewModel: mapViewModel)
        }
        .ignoresSafeArea()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let locationService = LocationService()
        let gpxRecorder = GPXRecorder(locationService: locationService)
        let appSettingsManager = AppSettingsManager()
        let appCoordinator = AppCoordinator(gpxRecorder: gpxRecorder, locationService: locationService, appSettingsManager: appSettingsManager)
        let mapViewModel = MapViewModel(appCoorinator: appCoordinator)
        MainView(mapViewModel: mapViewModel)
            .environmentObject(appCoordinator)
    }
}

