//
//  MyEventsModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/07/25.
//

import Foundation

struct Event: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let date: String
    let location: String
    let endDate: String
    let buttonText: String
}

// MARK:- My Event Model View

struct SavedEventResponse: Codable {
    let success: Bool
    let code: Int
    let message: String
    let data: SavedEventPageData
}

struct SavedEventPageData: Codable {
    let page: Int
    let limit: Int
    let totalCount: Int
    let totalPage: Int
    let events: [SavedEvent]

    enum CodingKeys: String, CodingKey {
        case page
        case limit
        case totalCount = "total_count"
        case totalPage = "total_page"
        case events = "data"
    }
}

struct SavedEvent: Codable, Identifiable {
    let id: Int?
    let userId: Int?
    let eventTitle: String?
    let eventDescription: String?
    let eventStartDate: String?
    let eventStartTime: String?
    let eventEndDate: String?
    let eventEndTime: String?
    let eventDuration: String?
    let address: String?
    let latitude: String?
    let longitude: String?
    let city: String?
    let state: String?
    let zipCode: String?
    let eventType: String?
    let createdAt: String?
    let updatedAt: String?
    let images: [EventImage]?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case eventTitle = "event_title"
        case eventDescription = "event_description"
        case eventStartDate = "event_start_date"
        case eventStartTime = "event_start_time"
        case eventEndDate = "event_end_date"
        case eventEndTime = "event_end_time"
        case eventDuration = "event_duration"
        case address
        case latitude
        case longitude
        case city
        case state
        case zipCode = "zip_code"
        case eventType = "event_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case images = "get_event_image"
    }
}

struct EventImage: Codable, Identifiable {
    let id: Int?
    let eventId: Int?
    let mediaPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case eventId = "event_id"
        case mediaPath = "media_path"
    }
}
