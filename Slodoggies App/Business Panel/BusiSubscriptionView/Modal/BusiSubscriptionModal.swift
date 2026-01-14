//
//  BusiSubscriptionModal.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 29/08/25.
//

import Foundation

struct BusiSubscriptionModal: Identifiable {
    let id = UUID()
    let name: String
    let price: String
    let description: String
    let features: [String]
}
