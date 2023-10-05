//
//  StatusBar.swift
//  GPX Creator
//
//  Created by Maciej Gulda on 28/09/2023.
//

import SwiftUI
import MapKit

struct LocationInfo: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @StateObject var mapViewModel: MapViewModel

    var body: some View {
        VStack{
            HStack{
                let formatter =  MKDistanceFormatter()
                Text("Dis: \(formatter.string(fromDistance: mapViewModel.distance))")
                    .foregroundColor(.black)
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.vertical,1)
                Spacer()
            }
        }
        .padding(.horizontal,16)

    }
}

struct StatusBar_Previews: PreviewProvider {
    static var previews: some View {
        let locationService = LocationService()
        let gpxRecorder = GPXRecorder(locationService: locationService)
        let appSettingsManager = AppSettingsManager()
        let appCoordinator = AppCoordinator(gpxRecorder: gpxRecorder, locationService: locationService, appSettingsManager: appSettingsManager)
        let mapViewModel = MapViewModel(appCoorinator: appCoordinator)
        let fileBrowserViewModel = FileBrowserViewModel(appCoordinator: appCoordinator)
        LocationInfo(mapViewModel: mapViewModel)
            .environmentObject(appCoordinator)
    }
}
