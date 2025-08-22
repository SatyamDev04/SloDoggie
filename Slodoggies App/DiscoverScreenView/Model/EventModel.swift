//
//  EventModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/08/25.
//

import Foundation

struct DiscEventModel: Identifiable {
    let id = UUID()
    let title: String
    let time: String
    let duration: String
    let location: String
    let image: String
    let likes: Int
    let shares: Int
}
