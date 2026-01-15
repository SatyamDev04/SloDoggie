//
//  BusiAdsViewModel.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 19/12/25.
//

import SwiftUI
import Combine
import _PhotosUI_SwiftUI

// MARK: - Simple Ads ViewModel (unchanged logic but cleaned)
class BusiAdsViewModel: ObservableObject {
    @Published var selectedTab: BusiPostTab = .ads
    @Published var selectedMedia: [MediaTypes] = []
    @Published var showImagePicker = false
    @Published var pickerItems: [PhotosPickerItem] = []
    @Published var adsData : adsDataModel?
    
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false
    private var cancellables = Set<AnyCancellable>()
    @Published var showActivity = false
    
    @MainActor
    func addMedia(from items: [PhotosPickerItem]) async {
        var newMedia: [MediaTypes] = []
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self) {
                if let image = UIImage(data: data) {
                    let newMediaItem = MediaTypes(image: image)   // ← CORRECT for images
                    if !selectedMedia.contains(newMediaItem) && !newMedia.contains(newMediaItem) {
                        newMedia.append(newMediaItem)
                    }
                    continue
                }

                // ... Same for videos
                let tempDir = FileManager.default.temporaryDirectory
                let filename = UUID().uuidString + ".mov"
                let tempURL = tempDir.appendingPathComponent(filename)
                do {
                    try data.write(to: tempURL, options: .atomic)
                    let asset = AVAsset(url: tempURL)
                    if !asset.tracks(withMediaType: .video).isEmpty {
                        let newMediaItem = MediaTypes(videoURL: tempURL) // Hash used here!
                        if !selectedMedia.contains(newMediaItem) && !newMedia.contains(newMediaItem) {
                            newMedia.append(newMediaItem)
                        }
                        continue
                    } else {
                        try? FileManager.default.removeItem(at: tempURL)
                    }
                } catch {
                    print("Failed to write temp video: \(error)")
                }
            }
            // ... Fallback for URL
            if let url = try? await item.loadTransferable(type: URL.self) {
                let tempDir = FileManager.default.temporaryDirectory
                let dest = tempDir.appendingPathComponent(UUID().uuidString + url.lastPathComponent)
                do {
                    try FileManager.default.copyItem(at: url, to: dest)
                    let asset = AVAsset(url: dest)
                    if !asset.tracks(withMediaType: .video).isEmpty {
                        let newMediaItem = MediaTypes(videoURL: dest)
                        if !selectedMedia.contains(newMediaItem) && !newMedia.contains(newMediaItem) {
                            newMedia.append(newMediaItem)
                        }
                    } else {
                        try? FileManager.default.removeItem(at: dest)
                    }
                } catch {
                    print("Failed to copy picker URL: \(error)")
                }
            }
        }
        // Merge + remove duplicates
        let combined = (selectedMedia + newMedia).uniqued()
        selectedMedia = Array(combined.prefix(6))
       // pickerItems.removeAll()
    }

    // MARK: - Remove media
    func removeMedia(at index: Int) {
        guard selectedMedia.indices.contains(index) else { return }
        selectedMedia.remove(at: index)
        pickerItems.removeAll()
    }
    
//    func createAddApi(completion: @escaping (Bool) -> Void) {
//        self.showActivity = true
//        
//        APIManager.shared.CreateAds(adsData: self.adsData ?? adsDataModel())
//            .sink { completionn in
//                self.showActivity = false
//                if case .failure(let error) = completionn {
//                    print("Failed with error: \(error.localizedDescription)")
//                    self.showError = true
//                    self.errorMessage = error.localizedDescription
//                    completion(false)
//                }
//            } receiveValue: { response in
//                if response.success  ?? false {
//                    self.selectedMedia.removeAll()
//                    self.pickerItems.removeAll()
//                    completion(true)
//                }else{
//                    self.showError = true
//                    self.errorMessage = response.message ?? "Something went wrong"
//                    completion(false)
//                }
//            }.store(in: &cancellables)
//      }
    
}
