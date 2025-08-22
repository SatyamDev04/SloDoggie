//
//  DiscoverViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/08/25.
//

import SwiftUI

class DiscoverViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var hashtags: [String] = ["#DogYoga", "#PupWalk2025", "#PetPicnic", "#GroomingGala", "#minis"]
    @Published var categories: [String] = ["People", "Pets Near You", "Events", "Pet Places", "Activities"]
    
    @Published var selectedCategory: String = "People"
    @Published var results: [DiscoverModel] = []
    @Published var events: [DiscoverEventModel] = []   // 👈 for events
    @Published var petPlaces: [PetPlaceModel] = []
    
    init() {
        selectCategory("People")
    }
    
    func selectCategory(_ category: String) {
        selectedCategory = category
        
        switch category {
        case "People":
            results = [
                DiscoverModel(name: "Justin Bator", role: "Pet Dad", imageName: "dog1"),
                DiscoverModel(name: "Martin", role: "Pet Dad", imageName: "dog2")
            ]
            
        case "Pets Near You":
            results = [
                DiscoverModel(name: "Jimmi", role: "Pet Dad", imageName: "dog1"),
                DiscoverModel(name: "Barry", role: "Pet Dad", imageName: "dog2"),
                DiscoverModel(name: "Jully", role: "Pet Mom", imageName: "dog3"),
                DiscoverModel(name: "Tinni", role: "Pet Mom", imageName: "dog4"),
                DiscoverModel(name: "Rocky", role: "Pet Dad", imageName: "dog5")
            ]
            
        case "Events":
            events = [
                DiscoverEventModel(title: "Dog Yoga Meetup", time: "May 25, 4:00 PM", duration: "30 Mins.", location: "Central Park", image: "Post1", likes: 200, shares: 10),
                DiscoverEventModel(title: "Pet Picnic", time: "Jun 5, 11:00 AM", duration: "2 Hrs.", location: "Beach Side", image: "Post1", likes: 150, shares: 8)
            ]
            results = [] // clear people/pets list
            
        case "Pet Places":
            petPlaces = [
                PetPlaceModel(name: "Highway 1 Road Trip", place: "San Luis Obispo", distance: "10 km", imageName: "image"),
                PetPlaceModel(name: "Avila Beach", place: "San Luis Obispo", distance: "10 km", imageName: "image 1"),
                PetPlaceModel(name: "El Chorro Dog Park", place: "San Luis Obispo", distance: "30 km", imageName: "image 2"),
                PetPlaceModel(name: "Springdale Pet Ranch", place: "San Luis Obispo", distance: "40 km", imageName: "image 3")
            ]
            results = []
            
        case "Activities":
            results = [
                DiscoverModel(name: "Morning Dog Walk", role: "Exercise", imageName: "activity1"),
                DiscoverModel(name: "Puppy Training", role: "Learning", imageName: "activity2")
            ]
            
        default:
            results = []
        }
    }
    
    func removeItem(_ item: DiscoverModel) {
        results.removeAll { $0.id == item.id }
    }
}


struct DiscoverEventModel: Identifiable {
    let id = UUID()
    let title: String
    let time: String
    let duration: String
    let location: String
    let image: String
    let likes: Int
    let shares: Int
}
