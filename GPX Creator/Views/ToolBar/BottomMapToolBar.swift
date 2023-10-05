//
//  BottomMapToolBar.swift
//  GPX Creator
//
//  Created by Maciej Gulda on 27/09/2023.
//

import SwiftUI

struct BottomMapToolBar: View {
    @EnvironmentObject var appCoordinator: AppCoordinator

    @State private var selection: ToolBarState = .mapPreview
    @State private var fadeInOut = false
    @StateObject var mapViewModel: MapViewModel
    @StateObject var fileBrowserViewModel: FileBrowserViewModel

    enum ToolBarState {
            case mapPreview
            case recording
            case edit
            case settings
        }
    
    var body: some View {
        HStack{
            switch selection {
            case .mapPreview:
                BottomMapToolBarMapPreview(selection: $selection, mapViewModel: mapViewModel, fileBrowserViewModel: fileBrowserViewModel, settingsViewModel: SettingsViewModel(appCoordinator: appCoordinator))
            case .recording:
                BottomMapToolBarRecording(selection: $selection, mapViewModel: mapViewModel)
            case .edit:
                Text("edit")
            case .settings:
                Text("settings")
            }
        }
    }
}

struct BottomMapToolBar_Previews: PreviewProvider {
    static var previews: some View {
        let locationService = LocationService()
        let gpxRecorder = GPXRecorder(locationService: locationService)
        let appSettingsManager = AppSettingsManager()
        let appCoordinator = AppCoordinator(gpxRecorder: gpxRecorder, locationService: locationService, appSettingsManager: appSettingsManager)
        let mapViewModel = MapViewModel(appCoorinator: appCoordinator)
        let fileBrowserViewModel = FileBrowserViewModel(appCoordinator: appCoordinator)
        BottomMapToolBar(mapViewModel: mapViewModel, fileBrowserViewModel: fileBrowserViewModel)
            .environmentObject(appCoordinator)
    }
}
