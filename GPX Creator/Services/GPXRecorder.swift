
//
//  GPXRecorder.swift
//  GPX Creator
//
//  Created by Maciej Gulda on 24/09/2023.
//

import Foundation
import CoreGPX
import Combine
import CoreLocation

class GPXRecorder: ObservableObject, GPXRecorderProtocol {
    
    static let TrackPathComponent = "Tracks"
    private var cancellables: Set<AnyCancellable> = []
    private var locationService: LocationService
    private var root: GPXRoot!
    private var trackpoints = [GPXTrackPoint]()
    private var prevLocation: CLLocation!
    private var startDate: Date = Date()
    
    @Published var distance: Double = 0;
    @Published var isRecording: Bool = false
    @Published var fileLoaded: [CLLocationCoordinate2D] = []
    
    init (locationService: LocationService ) {
        self.locationService = locationService
        isRecording = false
        self.locationService.enableBackgroundMode(enabled: false)
        setupObservers()
    }
    
    private func setupObservers() {
        self.locationService.$currentLocation.receive(on: DispatchQueue.main)
            .sink { newLocation in
                if let newLocation = newLocation {
                    self.updateData(location: newLocation)
                }
            }
            .store(in: &cancellables)
    }
    
    private var fileName: String {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        return GPXRecorder.TrackPathComponent + "_\(dateFormatter.string(from: startDate))"
    }
    
    func startFile() {
        fileLoaded.removeAll()
        self.locationService.enableBackgroundMode(enabled: true)
        startDate = Date()
        root = GPXRoot(creator: Version.appName )
        trackpoints.removeAll()
        isRecording = true
        distance = 0
        prevLocation = nil
    }
    
    func loadFile(path: URL) {
        let parser = GPXParser(withURL: path)
        if let root = parser?.parsedData() {
            self.root = root
            var newFileData: [CLLocationCoordinate2D] = []
            for track in root.tracks {
                for segment in track.segments {
                    for point  in segment.points {
                        if let latitude = point.latitude, let longitude = point.longitude {
                            newFileData.append(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                        }
                    }
                }
            }
            DispatchQueue.main.async { [weak self] in 
                if newFileData.count > 0 {
                    self?.fileLoaded = newFileData
                }
            }
        }
    }
    
    private func updateData(location: CLLocation) {
        if let prevLocation = prevLocation, isRecording {
            let trackpoint = GPXTrackPoint(latitude: location.coordinate.latitude,
                                       longitude: location.coordinate.longitude)
            trackpoint.elevation = location.altitude
            trackpoint.time = Date()
            trackpoints.append(trackpoint)
            distance += location.distance(from: prevLocation)
            print("dist: \(distance)")
        }
        prevLocation = location
    }
    
    func stopFile() {
        self.locationService.enableBackgroundMode(enabled: false)
        let track = GPXTrack()
        let tracksegment = GPXTrackSegment()
        tracksegment.add(trackpoints: trackpoints)
        track.add(trackSegment: tracksegment)
        root.add(track: track)
                
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let workingDir = dir.appendingPathComponent(GPXRecorder.TrackPathComponent, conformingTo: .folder)
            do {
                try? FileManager.default.createDirectory(at: workingDir, withIntermediateDirectories: true)
                try? root.outputToFile(saveAt: workingDir, fileName: fileName)
                        
                let fileInfo = FileInfo(distance: distance)
                if let fileJson = try? JSONEncoder().encode(fileInfo), let fileToSave = String(data: fileJson, encoding: .utf8) {
                    let fileURL = workingDir.appendingPathComponent(fileName).appendingPathExtension("json")
                    do {
                        try fileToSave.write(to: fileURL, atomically: false, encoding: .utf8)
                    }
                    catch { }
                }
            }
            trackpoints.removeAll()
            isRecording = false
        }
    }
}
