//
//  SavedViewModal.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 16/07/25.
//

import Foundation

class SavedViewModel: ObservableObject {
    @Published var mediaItems: [MediaItem] = []
    @Published var selectedIndex: Int? = nil
    
    init() {
        loadMedia()
    }

    func loadMedia() {
        // Static sample data, you can replace this with API call
        mediaItems = [
            MediaItem(mediaType: .image, thumbnail: "dog1", videoURL: nil),
            MediaItem(mediaType: .video, thumbnail: "videoThumb2", videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")),
            MediaItem(mediaType: .image, thumbnail: "dog3", videoURL: nil),
            MediaItem(mediaType: .image, thumbnail: "dog4", videoURL: nil),
            MediaItem(mediaType: .image, thumbnail: "dog5", videoURL: nil),
            MediaItem(mediaType: .video, thumbnail: "videoThumb2", videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")),
            MediaItem(mediaType: .image, thumbnail: "dog7", videoURL: nil),
            MediaItem(mediaType: .video, thumbnail: "videoThumb2", videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")),
            MediaItem(mediaType: .image, thumbnail: "dog9", videoURL: nil),
            MediaItem(mediaType: .image, thumbnail: "dog10", videoURL: nil),
            MediaItem(mediaType: .image, thumbnail: "dog3", videoURL: nil),
            MediaItem(mediaType: .video, thumbnail: "videoThumb2", videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"))
        ]
    }
    func selectItem(at index: Int) {
        selectedIndex = index
    }
    
    func closeViewer() {
        selectedIndex = nil
    }
}

