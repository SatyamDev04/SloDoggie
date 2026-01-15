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

// MARK: - Welcome
struct PostGalleryData: Codable {
    let page: String?
    let limit, totalData, totalPage: Int?
    let data: [PostGalleryList]?

    enum CodingKeys: String, CodingKey {
        case page, limit
        case totalData = "total_data"
        case totalPage = "total_page"
        case data
    }
}

// MARK: - Datum
struct PostGalleryList: Codable {
    let id, userID, petID: Int?
    let postTitle, address, latitude, longitude: String?
    let city, state, zipCode: String?
    let postType, createdAt, updatedAt: String?
    let mediaPath: [MediaItems]?
    let eventTitle, eventDescription, eventStartDate, eventStartTime: String?
    let eventEndDate, eventEndTime, eventDuration, eventType: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case petID = "pet_id"
        case postTitle = "post_title"
        case address, latitude, longitude, city, state
        case zipCode = "zip_code"
        case postType = "post_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case mediaPath = "media"
        case eventTitle = "event_title"
        case eventDescription = "event_description"
        case eventStartDate = "event_start_date"
        case eventStartTime = "event_start_time"
        case eventEndDate = "event_end_date"
        case eventEndTime = "event_end_time"
        case eventDuration = "event_duration"
        case eventType = "event_type"
    }
}
struct MediaItems: Codable {
    let url: String?
    let type: String?
}
