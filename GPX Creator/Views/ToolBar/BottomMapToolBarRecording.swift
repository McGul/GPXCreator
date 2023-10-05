//
//  BottomMapToolBarRecording.swift
//  GPX Creator
//
//  Created by Maciej Gulda on 28/09/2023.
//

import SwiftUI
import MapKit

struct BottomMapToolBarRecording: View {
    @Binding var selection: BottomMapToolBar.ToolBarState
    @EnvironmentObject var appCoordinator: AppCoordinator
    @StateObject var mapViewModel: MapViewModel
    @State private var fadeInOut = false
    
    var body: some View {
            HStack {
                Button() {
                    mapViewModel.stopRecording()
                    selection = .mapPreview
                } label: {
                    Image("stop")
                        .resizable()
                        .frame(width: 60,height: 60)
                }
                .frame(width: 70)
                .controlSize(.large)
                
                VStack(alignment: .leading){
                    Text("  Recording  ")
                        .background(.red)
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.bold)
                        .clipShape(Capsule(style: .circular))
                        .onAppear() {
                            withAnimation(Animation.easeInOut(duration: 1.3)
                                .repeatForever(autoreverses: true)) {
                                    fadeInOut.toggle()
                                }
                        }
                        .opacity(fadeInOut ? 0 : 1 )
                    Spacer()
                    let formatter =  MKDistanceFormatter()
                    Text("Distance:\(formatter.string(fromDistance: mapViewModel.distance))")
                        .foregroundStyle(.white)
                        .font(.title2)
                }
                Spacer()
            }
            .frame(height: 60)
            .frame(maxWidth: 330)
            .padding(.top,12)
            .padding(.bottom,12)
            .padding(.horizontal,12)
            .background(Color.black.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    
}

struct BottomMapToolBarMapPreview_Recording: PreviewProvider {
    static var previews: some View {
        @State var selection = BottomMapToolBar.ToolBarState.mapPreview
        
        let locationService = LocationService()
        let gpxRecorder = GPXRecorder(locationService: locationService)
        let appSettingsManager = AppSettingsManager()
        let appCoordinator = AppCoordinator(gpxRecorder: gpxRecorder, locationService: locationService, appSettingsManager: appSettingsManager)
        let mapViewModel = MapViewModel(appCoorinator: appCoordinator)
        
        BottomMapToolBarRecording(selection: $selection, mapViewModel: mapViewModel)
            .environmentObject(appCoordinator)
    }
}
