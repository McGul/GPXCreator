//
//  GPX_CreatorApp.swift
//  GPX Creator
//
//  Created by Maciej Gulda on 26/09/2023.
//

import SwiftUI

@main
struct GPX_CreatorApp: App {
    
    var locationService: LocationService!
    var gpxRecorder: GPXRecorder!
    var appSettingsManager: AppSettingsManager!
    var appCoordinator: AppCoordinator!
    
    var body: some Scene {
        WindowGroup {
            MainView(mapViewModel: MapViewModel(appCoorinator: appCoordinator))
                .environmentObject(appCoordinator)
        }
    }
    
    init() {
        locationService = LocationService()
        gpxRecorder = GPXRecorder(locationService: locationService)
        appSettingsManager = AppSettingsManager()
        appCoordinator = AppCoordinator(gpxRecorder: gpxRecorder, locationService: locationService, appSettingsManager: appSettingsManager)
    }
}
