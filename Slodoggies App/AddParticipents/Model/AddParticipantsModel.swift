//
//  AddParticipantsModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 17/07/25.
//

import Foundation

struct AddParticipant: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let imageName: String
}
