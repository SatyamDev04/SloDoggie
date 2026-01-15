//
//  EditBusinessModal.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 02/09/25.

import Foundation
import SwiftUI
//
//struct EditBusinessModal {
//    var name: String = ""
//    var providerName: String = ""
//    var bussinessLogo: String = ""
//    var email: String = ""
//    var bio : String = ""
//    var businessAddress: String = ""
//    var city: String = ""
//    var state: String = ""
//    var zipCode: String = ""
//    var categories: [String] = []
//    var location: String = ""
//    var website: String = ""
//    var contact: String = ""
//    var availableHours: String = ""
//    var documentImage: UIImage? = nil
//}

struct EditBusinessModal: Codable {

    var providerName: String = ""
    var businessName: String = ""
    var email: String = ""
    var phone: String = ""
    var bio: String = ""

    var categories: [String] = []

    var address: String = ""
    var city: String = ""
    var state: String = ""
    var zipCode: String = ""

    var latitude: String = ""
    var longitude: String = ""
    var websiteURL: String = ""

    var businessLogo: String = ""

    var availableDays: [String] = []
    var availableTime: String = ""
}





//// MARK: - DataClass
//struct EditBusinessModal: Codable {
//    let id, userID: Int?
//    let providerName, businessName, email, phone: String?
//    let bio: String?
//    let category: [String]?
//    let address, city, state, zipCode: String?
//    let latitude, longitude, websiteURL: String?
//    let businessLogo: String?
//    let availableDays: [String]?
//    let availableTime: String?
//    let verificationDocs: [String]?
//    let userStatus: Int?
//    let createdAt, updatedAt, postCount, followerCount: String?
//    let followingCount: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case userID = "user_id"
//        case providerName = "provider_name"
//        case businessName = "business_name"
//        case email, phone, bio, category, address, city, state
//        case zipCode = "zip_code"
//        case latitude, longitude
//        case websiteURL = "website_url"
//        case businessLogo = "business_logo"
//        case availableDays = "available_days"
//        case availableTime = "available_time"
//        case verificationDocs = "verification_docs"
//        case userStatus = "user_status"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case postCount = "post_count"
//        case followerCount = "follower_count"
//        case followingCount = "following_count"
//    }
//}
//
