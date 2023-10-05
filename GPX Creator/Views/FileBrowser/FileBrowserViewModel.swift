//
//  FileBrowserViewModel.swift
//  GPX Creator
//
//  Created by Maciej Gulda on 24/09/2023.
//

import Foundation
import SwiftUI
import Combine
import UIKit

class FileBrowserViewModel: ObservableObject {
    
    @ObservedObject var appCoordinator: AppCoordinator
    @Published var files = [FileItem]()
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    func loadFile(id: Int) {
        DispatchQueue.global(qos: .default).async  { [weak self] in
            if let item = self?.files.filter({ $0.id == id }).first {
                if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let workingDir = dir.appendingPathComponent(GPXRecorder.TrackPathComponent, conformingTo: .folder)
                    let file = workingDir.appendingPathComponent(item.fileName, conformingTo: .fileURL)
                    self?.appCoordinator.loadFile(path: file)
                }
            }
        }
    }
    
    func removeFile(index: Int) {
        let itemToRemove = files[index]
        removeFile(id:itemToRemove.id)
    }
    
    func shareFileUrl(id: Int) -> URL? {
        
        if let item = files.filter({ $0.id == id }).first {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let workingDir = dir.appendingPathComponent(GPXRecorder.TrackPathComponent, conformingTo: .folder)
                return workingDir.appendingPathComponent(item.fileName, conformingTo: .fileURL)
            } else {
                return nil
            }            
        } else {
            return nil
        }
    }
    
    func removeFile(id: Int) {
        if let item = files.filter({ $0.id == id }).first {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let workingDir = dir.appendingPathComponent(GPXRecorder.TrackPathComponent, conformingTo: .folder)
                let file = workingDir.appendingPathComponent(item.fileName, conformingTo: .fileURL)
                try? FileManager.default.removeItem(at: file)
                refreshFiles()
            }
        }
    }
    
    func refreshFiles() {
        DispatchQueue.global(qos: .default).async  { [weak self] in
            var newFiles = [FileItem]()
            
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let workingDir = dir.appendingPathComponent(GPXRecorder.TrackPathComponent, conformingTo: .folder)
                if let dirContents = FileManager.default.enumerator(at: workingDir.resolvingSymlinksInPath(), includingPropertiesForKeys: [.creationDateKey,.fileSizeKey]) {
                    for case let url as URL in dirContents {
                        if url.pathExtension == "gpx" {
                            let size = (try? url.resourceValues(forKeys: [.fileSizeKey]))?.fileSize
                            let date = (try? FileManager.default.attributesOfItem(atPath: url.absoluteString))?[.creationDate] as? Date
                            
                            let fileInfoURL = url.deletingPathExtension().appendingPathExtension("json")
                            let fileInfoRead = (try? String(contentsOf: fileInfoURL, encoding: .utf8)) ?? ""
                            let stringData: Data! = fileInfoRead.data(using: .utf8)
                                
                            let fileInfo = (try? JSONDecoder().decode(FileInfo.self, from: stringData)) ?? FileInfo(distance: 0)
                                                        
                            newFiles.append (
                                FileItem(id: 0,
                                         fileName: url.lastPathComponent,
                                         filedate: date ?? Date(),
                                         fileSize: size ?? 0, 
                                         fileInfo: fileInfo))
                        }
                    }
                    
                    newFiles.sort{ $0.fileName > $1.fileName }
                    var id = 0
                    
                    let sorted = newFiles.map { item in
                        
                        let newItem = FileItem(id: id,
                                               fileName: item.fileName,
                                               filedate: item.filedate,
                                               fileSize: item.fileSize, 
                                               fileInfo: item.fileInfo)
                        id += 1
                        return newItem
                    }
                    newFiles = sorted
                }
            }
            DispatchQueue.main.async {
                self?.files = newFiles
            }
        }
    }
}
