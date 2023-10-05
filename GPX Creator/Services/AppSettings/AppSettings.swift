//
//  AppSettings.swift
//  GPX Creator
//
//  Created by Maciej Gulda on 29/09/2023.
//

import Foundation

struct AppSettings {
    var mapStyle: AppSettingsManager.mapStyleEnum = .standard
    var gpsFiltering: Bool = true
}

class AppSettingsManager: ObservableObject {
    private let userDefaults = UserDefaults.standard
    static let mapStyleKey = "mapStyleKey"
    static let gpsFiltering = "gpsFilteringKey"
    
    @Published var applicationSettings: AppSettings
    
    init() {
        applicationSettings = AppSettings()
        applicationSettings.mapStyle = mapStyle
        applicationSettings.gpsFiltering = gpsFiltering
    }
    
    enum mapStyleEnum: Int {
        case standard = 0
        case hybrid = 1
        case sattelite = 2
    }
    
    var gpsFiltering: Bool {
        set {
            userDefaults.setValue(newValue, forKey: AppSettingsManager.gpsFiltering)
            applicationSettings.gpsFiltering = newValue
        }
        
        get {
            let filtering = userDefaults.bool(forKey: AppSettingsManager.gpsFiltering) 
            applicationSettings.gpsFiltering = filtering
            return filtering
        }
    }
    
    var mapStyle: mapStyleEnum {
        set {
            userDefaults.setValue(newValue.rawValue, forKey: AppSettingsManager.mapStyleKey)
            self.applicationSettings.mapStyle = newValue
        }
        get {
            let mapStyle = mapStyleEnum(rawValue: userDefaults.integer(forKey: AppSettingsManager.mapStyleKey)) ?? .standard
            applicationSettings.mapStyle = mapStyle
            return mapStyle
        }
    }
}
