//
//  ProviderModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 25/07/25.
//

import Foundation

struct ProviderModel: Identifiable {
    let id: UUID
    let name: String
    let rating: Double
    let address: String
    let phone: String
    let website: String
    let description: String
    var isFollowing: Bool
    let services: [Service]
    let reviews: [Review]
    let galleryImages: [String] // image URLs or asset names
}

struct Service: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let price: Double
    let photos: [String]
}

struct Review: Identifiable {
    let id: UUID
    let reviewerName: String
    let rating: Int
    let comment: String
    let timeAgo: String
}
