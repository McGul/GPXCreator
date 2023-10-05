//
//  FileItem.swift
//  GPX Creator
//
//  Created by Maciej Gulda on 27/09/2023.
//

import Foundation

struct FileItem: Identifiable {
    var id: Int
    var fileName: String
    var filedate: Date
    var fileSize: Int
    var fileInfo: FileInfo
}

struct FileInfo: Codable {
    var distance: Double
    enum CodingKeys: CodingKey {
        case distance
    }
}
