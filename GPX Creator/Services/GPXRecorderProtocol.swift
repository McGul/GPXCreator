//
//  GPXRecorderProtocol.swift
//  GPX Creator
//
//  Created by Maciej Gulda on 24/09/2023.
//

import Foundation

protocol GPXRecorderProtocol {
    func startFile()
    func stopFile()
    func loadFile(path: URL)
}
