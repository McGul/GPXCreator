//
//  AppCoordinatorProtocol.swift
//  GPX Creator
//
//  Created by Maciej Gulda on 26/09/2023.
//

import Foundation

protocol AppCoordinatorProtocol {
    var appSettings: AppSettings { get set }
    
    func startLocationService()
    func stopLocationService()
    func startGPXRecording()
    func stopGPXRecording()
    func loadFile(path: URL)
}
