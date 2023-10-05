//
//  Version.swift
//  GPX Creator
//
//  Created by Maciej Gulda on 26/09/2023.
//

import Foundation
import UIKit

final class Version {
    
    fileprivate init() { }

    fileprivate static func getBundleKey(_ key: String) -> String {
        return (Bundle.main.object(forInfoDictionaryKey: key)) as! String
    }

    static var version: String {
        return getBundleKey("CFBundleShortVersionString")
    }

    static var build: String {
        return getBundleKey("CFBundleVersion")
    }

    static var appName: String {
        return getBundleKey("CFBundleDisplayName")
    }
    
    fileprivate static var buildRevision: String {
        return getBundleKey("BuildRevision")
    }

    fileprivate static var buildTime: String {
        return getBundleKey("BuildTime")
    }
}
