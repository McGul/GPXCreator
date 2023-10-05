//
//  SettingsViewModel.swift
//  GPX Creator
//
//  Created by Maciej Gulda on 29/09/2023.
//

import Foundation
import SwiftUI
import Combine
import UIKit

class SettingsViewModel: ObservableObject {
    
    @ObservedObject var appCoordinator: AppCoordinator
    @Published var appSettings: AppSettings
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
        self.appSettings = appCoordinator.appSettings
    }
    
    func setGPSFiltering(filtering: Bool ) {
        appCoordinator.appSettings.gpsFiltering = filtering
    }
    
    func setMapStyle(mapStyle: AppSettingsManager.mapStyleEnum) {
        appCoordinator.appSettings.mapStyle = mapStyle
        mapStyleIndex = mapStyle.rawValue
    }
    
    var mapStyles = ["Standard","Hybrid","Satellite"]
    
    var mapStyleIndex: Int {
        get {
            appCoordinator.appSettings.mapStyle.rawValue
        }
        set { 
            appCoordinator.appSettings.mapStyle = AppSettingsManager.mapStyleEnum(rawValue: newValue) ?? .standard
        }
    }
    
    var gpsFiltering: Bool {
        get {
            return appCoordinator.appSettings.gpsFiltering
        }
    }
}
