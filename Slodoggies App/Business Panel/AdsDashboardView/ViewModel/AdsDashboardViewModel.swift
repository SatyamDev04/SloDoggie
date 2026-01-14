//
//  AdsDashboardViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 27/08/25.
//

import SwiftUI

class AdsDashboardViewModel: ObservableObject {
    @Published var selectedTab: AdTab = .approved
    @Published var ads: [AdsDashboardModel] = [
        AdsDashboardModel(
            title: "Free First Walk",
            status: .live,
            messageLeads: 25
        ),
        AdsDashboardModel(
            title: "Cat Food Discount",
            status: .expired,
            messageLeads: 0
        ),
        AdsDashboardModel(
            title: "Vet Consultation Offer",
            status: .pending,
            messageLeads: 0
        ),
        AdsDashboardModel(
            title: "Cat Food Discount",
            status: .approved,     // Added for Approved tab
            messageLeads: 0
        ),
        AdsDashboardModel(
            title: "Pet Grooming Discount",
            status: .approved,     // Added another approved ad
            messageLeads: 0
        )
    ]

    
    // Another dataset
       @Published var moreAds: [AdsDashboardModel] = [
           AdsDashboardModel(
               title: "Ad Title",
               status: .live,
               messageLeads: 25
           ),
           AdsDashboardModel(
               title: "Pet Toys Sale",
               status: .expired,
               messageLeads: 0
           )
        ]
     }


enum AdTab: String, CaseIterable {
    case approved = "Approved"
    case active = "Active"
    case pending = "Pending"
    case expired = "Expired"
}

struct AdsDashboardModel: Identifiable {
    let id = UUID()
    let title: String
    let status: AdStatus
    let messageLeads: Int
    let clicks: Int = 1200
    let impression: Int = 1800
    let expiryDate: String = "09/25/2025"
}

enum AdStatus: String {
    case approved = ""
    case live = "Live"
    case expired = "Expired"
    case pending = "Under Review"
    
    var tabType: AdTab {
        switch self {
        case .approved: return .approved
        case .live: return .active
        case .expired: return .expired
        case .pending: return .pending
        }
     }
  }
