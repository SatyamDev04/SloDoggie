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
