//
//  MyEventsModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/07/25.
//

import Foundation

struct Event: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let date: String
    let location: String
    let duration: String
    let buttonText: String
}
