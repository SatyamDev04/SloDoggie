//
//  BusiPostEventViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 17/09/25.
//

import SwiftUI
import PhotosUI
import AVFoundation
import AVKit
import UIKit
import CryptoKit
import Combine
//
func fileHash(for url: URL) -> String? {
    guard let data = try? Data(contentsOf: url) else { return nil }
    let hash = SHA256.hash(data: data)
    return hash.compactMap { String(format: "%02x", $0) }.joined()
}
//
// MARK: - Tabs
enum BusiPostTab: CaseIterable {
    case post, event, ads

    var title: String {
        switch self {
        case .post: return "New Post"
        case .event: return "New Event"
        case .ads: return "New Promotion"
        }
    }

    var tabLabel: String {
        switch self {
        case .post: return "Post"
        case .event: return "Event"
        case .ads: return "Ads"
        }
    }
}


// MARK: - Thumbnail Cache & Generator
final class ThumbnailCache {
    static let shared = ThumbnailCache()
    private let cache = NSCache<NSURL, UIImage>()

    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    func set(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }

    // Generate thumbnail off main thread
    func generateThumbnail(from url: URL, at timeSeconds: Double = 0.5) async -> UIImage? {
        if let cached = image(for: url) { return cached }
        return await withCheckedContinuation { cont in
            DispatchQueue.global(qos: .userInitiated).async {
                let asset = AVAsset(url: url)
                let gen = AVAssetImageGenerator(asset: asset)
                gen.appliesPreferredTrackTransform = true
                gen.maximumSize = CGSize(width: 800, height: 800)
                let time = CMTime(seconds: timeSeconds, preferredTimescale: 600)
                var actualTime = CMTime.zero
                do {
                    let cgImage = try gen.copyCGImage(at: time, actualTime: &actualTime)
                    let ui = UIImage(cgImage: cgImage)
                    self.set(ui, for: url)
                    cont.resume(returning: ui)
                } catch {
                    cont.resume(returning: nil)
                }
            }
        }
    }
}

// MARK: - Main ViewModel
@MainActor
class BusiPostEventViewModel: ObservableObject {
    @Published var selectedMedia: [MediaTypes] = []
    @Published var pickerItems: [PhotosPickerItem] = []
    @Published var selectedTab: BusiPostTab = .post
    
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false
    private var cancellables = Set<AnyCancellable>()
    @Published var showActivity = false
    
    @Published var address = ""

    @Published var city = ""
    @Published var state = ""
    @Published var zipCode = ""

    @Published var latitude: Double?
    @Published var longitude: Double?
    
    // Post And Event Data which goes in API
    @Published var postData : PostData?
    @Published var eventData : eventData?
    
    // MARK: - Add new media (No duplicates, max 6)
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
    
//    func createEventApi(completion: @escaping (Bool) -> Void) {
//        
//        self.showActivity = true
//        
//        let startDateTime = convertDateTime(from: eventData?.startDateTime ?? "")
//        let endDataTime = convertDateTime(from: eventData?.endDateTime ?? "")
//        
//        APIManager.shared.CreateEvent(event_title: eventData?.eventTitle ?? "", event_description: eventData?.eventDesc ?? "", imgs: eventData?.media ?? [], event_start_date: startDateTime?.date ?? "", event_start_time: startDateTime?.time ?? "", event_end_date: endDataTime?.date ?? "", event_end_time: endDataTime?.time ?? "", event_duration: "", address: address, city: city, state: state, zip_code: zipCode, user_type: UserDefaults.standard.string(forKey: "userType") ?? "", latitude: "\(latitude ?? 0.0)", longitude: "\(longitude ?? 0.0)")
//            .sink { completionn in
//                self.showActivity = false
//                if case .failure(let error) = completionn {
//                    print("Failed to create event with error: \(error.localizedDescription)")
//                    self.showError = true
//                    self.errorMessage = error.localizedDescription
//                    completion(false)
//                }
//            } receiveValue: { response in
//                if response.success  ?? false {
//                    completion(true)
//                }else{
//                    self.showError = true
//                    self.errorMessage = response.message ?? "Something went wrong"
//                    completion(false)
//                }
//                
//            }.store(in: &cancellables)
//        
//    }
    
    func convertDateTime(from input: String) -> (date: String, time: String)? {
        
        // Input format: "20 Nov 2025 at 8:19 PM"
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd MMM yyyy 'at' h:mm a"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        // Convert string → Date
        guard let date = inputFormatter.date(from: input) else {
            print("Invalid Date Format")
            return nil
        }

        // Convert date → "yyyy-MM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let finalDate = dateFormatter.string(from: date)

        // Convert time → "hh:mma"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mma"
        let finalTime = timeFormatter.string(from: date)

        return (finalDate, finalTime)
    }
    
}

// MARK: - Uniqued Helper
extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}

// MARK: - Video Thumbnail View
struct VideoThumbnailView: View {
    let videoURL: URL
    @State private var thumbnail: UIImage? = nil
    @State private var loading = false

    var body: some View {
        ZStack {
            Group {
                if let thumb = thumbnail {
                    Image(uiImage: thumb)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.25))
                }
            }

            Image(systemName: "play.circle.fill")
                .font(.system(size: 28))
                .foregroundColor(.white)
                .shadow(radius: 2)
        }
        .onAppear(perform: loadThumbnailIfNeeded)
        .onChange(of: videoURL) { _ in loadThumbnailIfNeeded() }
    }

    private func loadThumbnailIfNeeded() {
        if let cached = ThumbnailCache.shared.image(for: videoURL) {
            thumbnail = cached
            return
        }
        guard !loading else { return }
        loading = true
        Task {
            let img = await ThumbnailCache.shared.generateThumbnail(from: videoURL)
            await MainActor.run {
                thumbnail = img
                loading = false
            }
        }
    }
}

