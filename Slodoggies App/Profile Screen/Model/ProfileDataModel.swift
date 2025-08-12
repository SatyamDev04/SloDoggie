//
//  ProfileDataModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 22/07/25.
//

import Foundation

struct Pet: Identifiable {
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

struct SelectedPet: Identifiable {
    let id: UUID = UUID() // or use your own unique ID
    let image: String
    let status: Int
}

struct User {
    var name: String
    var tag: String
    var bio: String
    var image: String
}

struct GalleryItem: Identifiable {
    let id: UUID
    let image: String
    let isVideo: Bool
}
