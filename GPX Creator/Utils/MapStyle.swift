//
//  AppSettingsManager.mapStyleEnum+MapStyle.swift
//  GPX Creator
//
//  Created by Maciej Gulda on 30/09/2023.
//

import Foundation
import _MapKit_SwiftUI

extension AppSettingsManager.mapStyleEnum {
    func toMapStyle() -> MapStyle {
        switch self {
        case .standard:
            return .standard
        case .hybrid:
            return .hybrid
        case .sattelite:
            return .imagery
        }
    }
}
