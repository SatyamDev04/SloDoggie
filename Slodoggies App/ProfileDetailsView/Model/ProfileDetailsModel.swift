//
//  DetailsModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/08/25.
//

import Foundation

struct PetDetails: Identifiable {
    let id: UUID
    var name: String
    var breed: String
    var age: String
    var bio: String
    var image: String // URL or asset name
    var posts: Int
    var followers: Int
    var following: Int
}

struct SelectedPetDetails: Identifiable {
    let id: UUID = UUID() // or use your own unique ID
    let image: String
    let status: Int
}

struct UserDetails {
    var name: String
    var tag: String
    var bio: String
    var image: String
}

struct GalleryItemDetails: Identifiable {
    let id: UUID
    let image: String
    let isVideo: Bool
}
