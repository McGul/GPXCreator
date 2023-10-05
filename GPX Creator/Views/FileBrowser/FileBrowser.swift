//
//  FileBrowser.swift
//  GPX Creator
//
//  Created by Maciej Gulda on 27/09/2023.
//

import SwiftUI
import UniformTypeIdentifiers
import MapKit

struct FileBrowser: View {
    @ObservedObject var viewModel: FileBrowserViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    @State private var selectedId = 0
    
    var body: some View {
        NavigationView {
            List() {
                
                ForEach(viewModel.files) { item in
                    VStack (alignment: .leading){
                        Text("\(item.fileName)")
                            .font(.title3)
                        Spacer()
                        HStack {
                            let formatter =  ByteCountFormatter()
                            Text("\(formatter.string(fromByteCount: Int64(item.fileSize)))")
                            Spacer()
                            let distanceFormatter =  MKDistanceFormatter()
                            Text("\(distanceFormatter.string(fromDistance: CLLocationDistance(item.fileInfo.distance)))")
                        }
                    }
                    
                    .contextMenu(menuItems: {
                        Button {
                            viewModel.loadFile(id: item.id)
                            dismiss()
                        } label: {
                            Label("Open", systemImage: "folder")
                        }
                        
                        ShareLink("Share file", item: viewModel.shareFileUrl(id: item.id)!)
                        
                        Divider()
                        
                        Button (role: .destructive) {
                            selectedId = item.id
                            showingDeleteAlert = true
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    })
                    .alert(isPresented: $showingDeleteAlert) {
                        Alert(title: Text("Delete file"), message: Text("Do you want to delete the file?"), primaryButton: .cancel(),
                              secondaryButton: .destructive(Text("Delete"), action: { viewModel.removeFile(id: selectedId)}))
                    }
                    .padding()
                    .frame(height: 50)
                }
            }
            .onAppear() {
                viewModel.refreshFiles()
            }
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
            .navigationTitle("Tracks")
        }
    }
}

struct FileBrowser_Previews: PreviewProvider {
    static var previews: some View {
        let locationService = LocationService()
        let gpxRecorder = GPXRecorder(locationService: locationService)
        let appSettingsManager = AppSettingsManager()
        let appCoordinator = AppCoordinator(gpxRecorder: gpxRecorder, locationService: locationService, appSettingsManager: appSettingsManager)
        let fileBrowserViewModel = FileBrowserViewModel(appCoordinator: appCoordinator)
        FileBrowser(viewModel: fileBrowserViewModel)
            .environmentObject(appCoordinator)
    }
}
