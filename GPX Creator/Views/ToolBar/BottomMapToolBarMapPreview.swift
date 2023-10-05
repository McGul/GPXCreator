//
//  BottomMapToolBarMapPreview.swift
//  GPX Creator
//
//  Created by Maciej Gulda on 28/09/2023.
//

import SwiftUI

struct BottomMapToolBarMapPreview: View {
    @Binding var selection: BottomMapToolBar.ToolBarState
    @EnvironmentObject var appCoordinator: AppCoordinator
    @StateObject var mapViewModel: MapViewModel
    @StateObject var fileBrowserViewModel: FileBrowserViewModel
    @StateObject var settingsViewModel: SettingsViewModel
    @State private var showingFiles = false
    @State private var showingSettings = false
    
    var body: some View {
        HStack{

            Button() {
                showingFiles.toggle()
            } label: {
                Image("gpx")
                    .resizable()
                    .frame(width: 60,height: 60)
            }
            .frame(width: 70)
            .sheet(isPresented: $showingFiles) {
                FileBrowser(viewModel: fileBrowserViewModel)
            }
            
            VStack() {
                Button() {
                    selection = .recording
                    mapViewModel.startRecording()
                } label: {
                    Image("record")
                        .resizable()
                        .frame(width: 60,height: 60)
                }
                .frame(width: 70)
                .controlSize(.large)
            }
            /*
            Button() {
                print("create")
            } label: {
                Image("plus")
                    .resizable()
                    .frame(width: 60,height: 60)
            }
            .frame(width: 70)
            .controlSize(.large)
            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            */
            Button() {
                showingSettings.toggle()
            } label: {
                Image("settings")
                    .resizable()
                    .frame(width: 60,height: 60)
            }
            .sheet(isPresented: $showingSettings) {
                Settings(settingsViewModel: settingsViewModel)
            }
        }
        .frame(maxWidth: 330)
        .frame(height: 60)
        .padding(.top,12)
        .padding(.bottom,12)
        .background(Color.black.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct BottomMapToolBarMapPreview_Previews: PreviewProvider {
    static var previews: some View {
        @State var selection = BottomMapToolBar.ToolBarState.mapPreview
        
        let locationService = LocationService()
        let gpxRecorder = GPXRecorder(locationService: locationService)
        let appSettingsManager = AppSettingsManager()
        let appCoordinator = AppCoordinator(gpxRecorder: gpxRecorder, locationService: locationService, appSettingsManager: appSettingsManager)
        let mapViewModel = MapViewModel(appCoorinator: appCoordinator)
        let fileBrowserViewModel = FileBrowserViewModel(appCoordinator: appCoordinator)
        let settingsViewModel = SettingsViewModel(appCoordinator: appCoordinator)
        BottomMapToolBarMapPreview(selection: $selection, mapViewModel: mapViewModel, fileBrowserViewModel: fileBrowserViewModel, settingsViewModel: settingsViewModel)
            .environmentObject(appCoordinator)
    }
}

