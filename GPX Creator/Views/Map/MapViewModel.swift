//
//  MapViewModel.swift
//  GPX Creator
//
//  Created by Maciej Gulda on 26/09/2023.
//

import Foundation
import MapKit
import SwiftUI
import Combine

class MapViewModel: ObservableObject {
    @ObservedObject var appCoordinator: AppCoordinator
    
    @Published var cameraPosition: MapCameraPosition
    @Published var isRecording: Bool
    @Published var recordedTrack: [CLLocationCoordinate2D] = []
    @Published var distance: Double
    @Published var location: CLLocationCoordinate2D
    @Published var mapStyle: MapStyle
    @Published var mapStyleIndex: Int
    @Published var gpsFiltering: Bool
    private var cancellables: Set<AnyCancellable> = []
    
    init (appCoorinator: AppCoordinator) {
        isRecording = false
        distance = 0
        location = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        self.appCoordinator = appCoorinator
        cameraPosition = .automatic
        mapStyle = appCoorinator.appSettings.mapStyle.toMapStyle()
        gpsFiltering = appCoorinator.appSettings.gpsFiltering
        mapStyleIndex = appCoorinator.appSettings.mapStyle.rawValue
        setupObservers()
    }
    
    private func setupObservers() {
        self.appCoordinator.$newAppSettings.receive(on: DispatchQueue.main)
            .sink { newSettings in
                self.mapStyle = newSettings.mapStyle.toMapStyle()
                self.gpsFiltering = newSettings.gpsFiltering
                self.mapStyleIndex = newSettings.mapStyle.rawValue
            }
            .store(in: &cancellables)
        
        self.appCoordinator.$currentLocation.receive(on: DispatchQueue.main)
            .sink { newLocation in
                if let coordinate = newLocation?.coordinate {
                    self.location = coordinate
                }
                if self.isRecording {
                    if let newLocation = newLocation {
                        self.distance = self.appCoordinator.distance
                        DispatchQueue.main.async {
                            self.recordedTrack.append(CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude))
                        }
                    }
                }
            }
            .store(in: &cancellables)
            
        self.appCoordinator.$fileLoaded.receive(on: DispatchQueue.main)
            .sink { newTrack in
                if !self.isRecording {
                    DispatchQueue.main.async {
                        self.recordedTrack = newTrack
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func start() {
        appCoordinator.startLocationService()
    }
    
    func stop() {
        appCoordinator.stopLocationService()
    }
    
    func startRecording() {
        distance = 0
        recordedTrack = []
        isRecording = true
        DispatchQueue.global(qos: .default).async {
            self.appCoordinator.startGPXRecording()
        }
    }
    
    func stopRecording() {
        isRecording = false
        DispatchQueue.global(qos: .default).async {
            self.appCoordinator.stopGPXRecording()
        }
    }
}
