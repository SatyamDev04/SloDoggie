//
//  EventCommViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 16/07/25.
//

import SwiftUI

class EventParticipantsViewModel: ObservableObject {
    @Published var eventName = "Event Community 1"
    @Published var participants: [Participant] = [
        Participant(name: "Lydia Vaccaro", imageName: "People1"),
        Participant(name: "Anika Torff", imageName: "People2"),
        Participant(name: "Zain Dorwart", imageName: "People3"),
        Participant(name: "Ryan Dias", imageName: "People4"),
        Participant(name: "Marcus Culhane", imageName: "People5"),
        Participant(name: "Cristofer Torff", imageName: "People6"),
        Participant(name: "Kierra Westervelt", imageName: "People1"),
        Participant(name: "Adison Dias", imageName: "People2")
    ]
}
