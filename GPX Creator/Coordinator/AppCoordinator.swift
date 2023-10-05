//
//  AppCoordinator.swift
//  GPX Creator
//
//  Created by Maciej Gulda on 26/09/2023.
//

import Foundation
import Combine
import CoreLocation

class AppCoordinator: ObservableObject, AppCoordinatorProtocol {
    private var gpxRecorder: GPXRecorder!
    private var locationService: LocationService!
    private var appSettingsManager: AppSettingsManager!
    
    @Published var distance: Double = 0;
    @Published var fileLoaded: [CLLocationCoordinate2D] = []
    @Published var currentLocation: CLLocation!
    @Published var newAppSettings: AppSettings
    
    var appSettings: AppSettings {
        get {
            return appSettingsManager.applicationSettings
        }
        
        set {
            appSettingsManager.gpsFiltering = newValue.gpsFiltering
            appSettingsManager.mapStyle = newValue.mapStyle
        }
    }
    private var cancellables: Set<AnyCancellable> = []
    
    init( gpxRecorder: GPXRecorder,
          locationService: LocationService,
          appSettingsManager: AppSettingsManager) {
        self.gpxRecorder = gpxRecorder
        self.locationService = locationService
        self.appSettingsManager = appSettingsManager
        self.newAppSettings = appSettingsManager.applicationSettings
        setupObservers()
    }
    
    private func setupObservers() {
        self.appSettingsManager.$applicationSettings.receive(on: DispatchQueue.main)
            .sink { newSettings in
                self.newAppSettings = newSettings
                self.locationService.gpsFiltring = newSettings.gpsFiltering
            }
            .store(in: &cancellables)
        
        self.gpxRecorder.$distance.receive(on: DispatchQueue.main)
            .sink { newDistance in
                if !newDistance.isNaN {
                    self.distance = newDistance
                }
            }
            .store(in: &cancellables)
        
        self.gpxRecorder.$fileLoaded.receive(on: DispatchQueue.main)
            .sink { newTrack in
                self.fileLoaded = newTrack
            }
            .store(in: &cancellables)
        
        self.locationService.$currentLocation.receive(on: DispatchQueue.main)
            .sink { newLocation in
                if let newLocation = newLocation {
                    self.currentLocation = newLocation
                }
            }
            .store(in: &cancellables)
    }
    
    func startLocationService() {
        locationService?.start()
    }

    func stopLocationService() {
        locationService?.stop()
    }

    func startGPXRecording() {
        gpxRecorder?.startFile()
    }
    
    func stopGPXRecording() {
        gpxRecorder?.stopFile()
    }
    
    func loadFile(path: URL) {
        gpxRecorder?.loadFile(path: path)
    }
}
