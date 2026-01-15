//
//  ServiceModelView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 24/07/25.
//

import Foundation

struct Provider: Identifiable {
    let id = UUID()
    let servieName: String
    let provideName: String
    let rating: Double
    let serviceType: String
    let iconName: String // e.g. "pawIcon"
}


// MARK:- Service Filter Chip Model
import Foundation

// MARK: - Main Response
struct CategoryResponse: Codable {
    let success: Bool?
    let code: Int?
    let message: String?
    let data: [Category]?
}

struct Category: Codable, Identifiable {
    let id = UUID()
    let categoryName: String?

    enum CodingKeys: String, CodingKey {
        case categoryName
    }
}

// MARK:- Get Service Provider View Model
import Foundation

struct OwnerServicesResponse: Codable {
    let success: Bool?
    let code: Int?
    let message: String?
    let data: [ServiceItem]?
}

struct ServiceItem: Codable, Identifiable {

    let serviceId: Int?
    let serviceName: String?
    let latitude: String?
    let longitude: String?
    let isBusinessVerified: Bool?
    let providerId: Int?
    let providerName: String?
    let image: String?
    let averageRating: String?
    let location: String?
    let distance: String?
    let categoryName: [String?]?

    var id: Int { serviceId ?? 0 }

    enum CodingKeys: String, CodingKey {
        case serviceId
        case serviceName
        case latitude
        case longitude
        case isBusinessVerified
        case providerId
        case providerName
        case image
        case averageRating
        case location
        case distance
        case categoryName
    }
}


//// MARK:- Get Service Provider Model
//import Foundation
//
//struct ServiceProviderResponse: Codable {
//    let success: Bool?
//    let code: Int?
//    let message: String?
//    let data: [ServiceProviderItem]?
//}
//
//// MARK: - Service Item
//struct ServiceProviderItem: Codable, Identifiable {
//    
//    // SwiftUI requires a unique id
//    let serviceId: Int?
//    let serviceName: String?
//    let isBusinessVerified: Bool?
//    let providerId: Int?
//    let providerName: String?
//    let image: String?
//    let averageRating: String?
//    let distance: String?
//    let categoryName: [String]?
//    
//    // Identifiable conformance
//    var id: Int { serviceId ?? 0 }
//    
//    enum CodingKeys: String, CodingKey {
//        case serviceId
//        case serviceName
//        case isBusinessVerified
//        case providerId
//        case providerName
//        case image
//        case averageRating
//        case distance
//        case categoryName
//    }
//}
//
