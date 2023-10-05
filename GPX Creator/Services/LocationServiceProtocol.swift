//
//  LocationServiceProtocol.swift
//  GPX Creator
//
//  Created by Maciej Gulda on 21/09/2023.
//

import Foundation

protocol LocationServiceProtocol {
    func enableBackgroundMode(enabled: Bool)
    func start()
    func stop()
}
