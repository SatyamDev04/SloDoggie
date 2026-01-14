//
//  Group&EventModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 29/07/25.
//

import Foundation
import UIKit

struct Pets: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let imageName: String
    var petImg: UIImage?
}

// MARK: - WelcomeElement
struct PetsDetailData: Codable, Hashable {
    let id: Int?
    let ownerUserID: Int?
    var petName, petBreed, petAge: String?
    var petImage: String?
    var petBio, createdAt, updatedAt: String?
    let deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case ownerUserID = "owner_user_id"
        case petName = "pet_name"
        case petBreed = "pet_breed"
        case petAge = "pet_age"
        case petImage = "pet_image"
        case petBio = "pet_bio"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

struct PostData{
    var petId:String?
    var postTitle:String?
    var media: [MediaTypes]?
    var hashtag: String?
    var address: String?
    var latitude: String?
    var longitude: String?
}

struct eventData{
    var eventTitle:String?
    var media: [MediaTypes]?
    var eventDesc:String?
    var startDateTime:String?
    var endDateTime:String?
    var duration:String?
    var address:String?
    var city:String?
    var state:String?
    var zipCode:String?
    var latitude:String?
    var longitude:String?
}

struct adsDataModel{
    var adTitle:String?
    var media: [MediaTypes]?
    var adDescription:String?
    var category:[String]?
    var service:String?
    var expiryDate:String?
    var expiryTime:String?
    var tNc:String?
    var address:String?
    var latitude:String?
    var longitude:String?
    var contactShowStatus:Int?
    var contactInfo:String?
    var budget:String?
}
