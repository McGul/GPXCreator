//
//  MapView.swift
//  GPX Creator
//
//  Created by Maciej Gulda on 26/09/2023.
//

import SwiftUI
import CoreLocationUI
import MapKit
import CoreLocation

struct MapView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @ObservedObject var mapViewModel: MapViewModel
    @State private var orientation = UIDevice.current.orientation

    var body: some View {
        ZStack(alignment: .topLeading) {
            NavigationStack {
                Map(position: $mapViewModel.cameraPosition,
                        interactionModes: [.zoom,.pan,.rotate,.pitch]) {
                    
                        MapPolyline(coordinates: mapViewModel.recordedTrack)
                            .stroke(.blue,lineWidth: 4)
                    
                }
                .mapStyle(mapViewModel.mapStyle)
                    .mapControls {
                        MapCompass()
                        .mapControlVisibility(.visible)
                        MapUserLocationButton()
                        .mapControlVisibility(.visible)
                        MapScaleView()
                        .mapControlVisibility(.visible)
                        MapPitchToggle()
                        .mapControlVisibility(.visible)
                    }
                    .onAppear() {
                        mapViewModel.start()
                    }
            }
            
            VStack(alignment: .trailing) {
                
                Spacer()
                VStack(alignment: .center) {
                    ZStack() {
                        Image(systemName: "map")
                            .controlSize(.extraLarge)
                            .foregroundColor(.blue)
                            Menu("       ") {
                                Button {
                                    appCoordinator.appSettings.mapStyle = .standard
                                } label: {
                                    Label("Standard", systemImage: mapViewModel.mapStyleIndex == 0 ? "checkmark" : "" )
                                }
                            
                            Button {
                                appCoordinator.appSettings.mapStyle = .hybrid
                            } label: {
                                Label("Hybrid", systemImage: mapViewModel.mapStyleIndex == 1 ? "checkmark" : "" )
                            }
                            Button {
                                appCoordinator.appSettings.mapStyle = .sattelite
                            } label: {
                                Label("Satellite", systemImage: mapViewModel.mapStyleIndex == 2 ? "checkmark" : "" )
                            }
                        }
                        .menuOrder(.fixed)
                        .controlSize(.extraLarge)
                    }
                    .frame(width: 43, height: 43)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .shadow(radius: 32)
                    .padding([.trailing],5)
                }
                
                VStack() {
                    ZStack {
                        Image(systemName: self.mapViewModel.gpsFiltering ? "waveform" : "waveform.slash")
                            .controlSize(.extraLarge)
                            .foregroundColor(.blue)
                        Button {
                            appCoordinator.appSettings.gpsFiltering.toggle()
                        } label: {
                            Text("       ")
                        }
                    }
                }
                .frame(width: 43, height: 43)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .shadow(radius: 32)
                .padding([.trailing],5)
                
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    BottomMapToolBar(mapViewModel: mapViewModel, fileBrowserViewModel: FileBrowserViewModel(appCoordinator: appCoordinator))
                        .padding(.bottom,32)
                        .padding([.horizontal],16)
                    Spacer()
                }
            }
             
        }.detectOrientation($orientation)
    }
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        let locationService = LocationService()
        let gpxRecorder = GPXRecorder(locationService: locationService)
        let appSettingsManager = AppSettingsManager()
        let appCoordinator = AppCoordinator(gpxRecorder: gpxRecorder, locationService: locationService, appSettingsManager: appSettingsManager)
        let mapViewModel = MapViewModel(appCoorinator: appCoordinator)
        MapView(mapViewModel: mapViewModel)
            .environmentObject(appCoordinator)
    }
}
