//
//  MyEventsViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/07/25.
//

import Foundation

class EventListViewModel: ObservableObject {
    @Published var selectedTab: String = "My Events"
    @Published var events: [Event] = []

    init() {
        loadEvents()
    }

    func loadEvents() {
        // In production, you'd fetch this from an API
        if selectedTab == "My Events" {
            events = [
                Event(imageName: "EventDog1", title: "Event Title", date: "May 25, 4:00 PM", location: "San Luis Obispo County", duration: "30 Mins.", buttonText: "View Community Chats"),
                Event(imageName: "EventDog2", title: "Event Title", date: "May 25, 4:00 PM", location: "San Luis Obispo County", duration: "30 Mins.", buttonText: "View Community Chats")
            ]
        } else {
            events = [
                Event(imageName: "EventDog3", title: "Event Title", date: "May 25, 4:00 PM", location: "San Luis Obispo County", duration: "30 Mins.", buttonText: "Join Community Chats"),
                Event(imageName: "EventDog4", title: "Event Title", date: "May 25, 4:00 PM", location: "San Luis Obispo County", duration: "30 Mins.", buttonText: "Join Community Chats")
            ]
        }
    }

    func selectTab(_ tab: String) {
        selectedTab = tab
        loadEvents()
    }
}
