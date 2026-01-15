//
//  WelcomeElement.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 23/12/25.
//


// MARK: - WelcomeElement
struct ServiceListModel: Codable {
    let serviceID: Int?
    let serviceName: String?
    let isBusinessVerified: Bool?
    let providerID: Int?
    let providerName: String?
    let image: String?
    let averageRating, location, categoryName: String?

    enum CodingKeys: String, CodingKey {
        case serviceID = "serviceId"
        case serviceName, isBusinessVerified
        case providerID = "providerId"
        case providerName, image, averageRating, location, categoryName
    }
}
