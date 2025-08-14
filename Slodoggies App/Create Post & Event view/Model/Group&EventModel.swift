//
//  Group&EventModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 29/07/25.
//

import Foundation

struct Pets: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let imageName: String
}
