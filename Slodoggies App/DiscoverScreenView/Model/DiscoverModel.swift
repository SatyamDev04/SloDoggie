//
//  DiscoverViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/08/25.
//

import Foundation

struct DiscoverModel: Identifiable {
    let id = UUID()
    let name: String
    let role: String
    let imageName: String
}

struct PetPlaceModel: Identifiable {
    let id = UUID()
    let name: String
    let place: String?
    let distance: String?
    let imageName: String
}
