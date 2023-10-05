//
//  Settings.swift
//  GPX Creator
//
//  Created by Maciej Gulda on 29/09/2023.
//

import SwiftUI

struct Settings: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var settingsViewModel: SettingsViewModel
    @Environment(\.dismiss) var dismiss
    
    var mapStyleValues: [AppSettingsManager.mapStyleEnum] = [.standard,.hybrid,.sattelite]
    @State private var mapStyleIndex: Int = 0
    @State private var gpsFiltering: Bool = true
    
    init (settingsViewModel: SettingsViewModel) {
        self.settingsViewModel = settingsViewModel
        self.mapStyleIndex = settingsViewModel.mapStyleIndex
        self.gpsFiltering = settingsViewModel.gpsFiltering
    }
    
    var body: some View {
        
        NavigationView {
            Form {
                Section(header: Text("Map"),content: {
                    HStack {
                        Image(uiImage: UIImage(systemName: "map")!)
                            .renderingMode(.template)
                            .foregroundColor(colorScheme == .light ? .black : .white)
                        Picker(selection: $mapStyleIndex, label: Text("Map Style")) {
                            ForEach(0 ..< settingsViewModel.mapStyles.count) {
                                Text(settingsViewModel.mapStyles[$0])
                            }
                        }
                        .onChange(of: mapStyleIndex) {
                            settingsViewModel.setMapStyle(mapStyle:mapStyleValues[mapStyleIndex] )
                        }
                    }
                    HStack {
                         Image(uiImage: UIImage(systemName: "waveform.slash")!)
                            .renderingMode(.template)
                            .foregroundColor(colorScheme == .light ? .black : .white)
                            Toggle(isOn: $gpsFiltering) {
                                Text("GPS Filtering")
                            }
                            .onChange(of: gpsFiltering) {
                                settingsViewModel.setGPSFiltering(filtering: gpsFiltering)
                            }
                        }
                    
                })
                
                Section(header: Text("About"),content: {
                    Text("Text 1")
                    Text("Text 2")
                })
            }
            .onAppear {
                mapStyleIndex = settingsViewModel.mapStyleIndex
                gpsFiltering = settingsViewModel.gpsFiltering
            }
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }.navigationTitle("Settings")

        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        let locationService = LocationService()
        let gpxRecorder = GPXRecorder(locationService: locationService)
        let appSettingsManager = AppSettingsManager()
        let appCoordinator = AppCoordinator(gpxRecorder: gpxRecorder, locationService: locationService, appSettingsManager: appSettingsManager)
        let settingsViewModel = SettingsViewModel(appCoordinator: appCoordinator)
        Settings(settingsViewModel:settingsViewModel)
    }
}
