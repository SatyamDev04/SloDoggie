//
//  SavedModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 16/07/25.
//

import Foundation

enum MediaType {
    case image
    case video
}

struct MediaItem: Identifiable {
    let id = UUID()
    let mediaType: MediaType
    let thumbnail: String // For images, or placeholder thumbnail
    let videoURL: URL?
}
