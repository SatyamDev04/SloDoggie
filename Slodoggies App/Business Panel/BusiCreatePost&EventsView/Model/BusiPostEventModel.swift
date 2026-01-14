//
//  BusiPostEventModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 17/09/25.
//

import Foundation
import UIKit

struct BusiPets: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let imageName: String
}
// MARK: - Media Model
struct MediaTypes: Identifiable, Hashable {
    let id: String
    let image: UIImage?
    let videoURL: URL?
    let videoIdentifier: String?

    init(image: UIImage) {
        self.image = image
        self.videoURL = nil
        self.id = UUID().uuidString
        self.videoIdentifier = nil
    }

    init(videoURL: URL) {
        self.image = nil
        self.videoURL = videoURL
        self.id = UUID().uuidString
        self.videoIdentifier = fileHash(for: videoURL) // RIGHT!
    }
    
    func hash(into hasher: inout Hasher) {
        if let videoIdentifier = videoIdentifier {
            hasher.combine(videoIdentifier)
        } else if let image = image, let imageData = image.pngData() {
            hasher.combine(imageData)
        }
    }

    static func == (lhs: MediaTypes, rhs: MediaTypes) -> Bool {
        if let lId = lhs.videoIdentifier, let rId = rhs.videoIdentifier {
            return lId == rId
        }
        if let lImage = lhs.image, let rImage = rhs.image,
             let lData = lImage.pngData(), let rData = rImage.pngData() {
            return lData == rData
        }
        return false
    }
}
