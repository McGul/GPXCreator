//
//  LocationService.swift
//  GPX Creator
//
//  Created by Maciej Gulda on 21/09/2023.
//

import Foundation
import CoreLocation
import Combine

class LocationService: NSObject, ObservableObject, LocationServiceProtocol {
    
    let locationManager: CLLocationManager
    var kalmanFilter: HCKalmanAlgorithm?
    var resetKalmanFilter: Bool = false
    
    @Published var currentLocation: CLLocation!
    
    var gpsFiltring: Bool = true
    
    init ( locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        self.locationManager.distanceFilter = 5
        self.locationManager.activityType = .fitness
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.delegate = self
        self.enableBackgroundMode(enabled: false)
    }
    
    func enableBackgroundMode(enabled: Bool) {
        self.locationManager.showsBackgroundLocationIndicator = enabled ? true : false
        self.locationManager.allowsBackgroundLocationUpdates = enabled ? true : false
        self.locationManager.pausesLocationUpdatesAutomatically = enabled ? false : false
    }
    
    func start() {
        resetKalmanFilter = true
        switch locationManager.authorizationStatus {
            
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
            
        case .notDetermined:
            locationManager.startUpdatingLocation()
            locationManager.requestAlwaysAuthorization()
        default:
            locationManager.startUpdatingLocation()
            break
        }
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        if let lastPostion = locations.last {
                
                if gpsFiltring {
                    if kalmanFilter == nil {
                        self.kalmanFilter = HCKalmanAlgorithm(initialLocation: lastPostion)
                    } else {
                        if let kalmanFilter = self.kalmanFilter {
                            if self.resetKalmanFilter == true {
                                kalmanFilter.resetKalman(newStartLocation: lastPostion)
                                self.resetKalmanFilter = false
                            } else {
                                currentLocation  = kalmanFilter.processState(currentLocation:lastPostion)
                            }
                        }
                    }
                } else {
                    currentLocation = lastPostion
                }
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Location error: \(error.localizedDescription)")
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            guard .authorizedWhenInUse == manager.authorizationStatus || .authorizedAlways == manager.authorizationStatus else { return }
            locationManager.requestAlwaysAuthorization()
        }
    }
