//
//  ProfileDataViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 22/07/25.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var pets: [Pet] = []
    @Published var selectedPet: Pet?
    @Published var user: User?
    @Published var galleryItems: [GalleryItem] = []

    init() {
        loadMockData()
    }

    func loadMockData() {
        // Set this empty to test the empty state
        let samplePet = Pet(id: UUID(), name: "Jimmi", breed: "Brown Breed", age: "3 Years Olds", bio: "Lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed ", image: "dog1", posts: 120, followers: 27700000, following: 219)
        let sampleUser = User(name: "Lydia Vaccara", tag: "Pet Mom", bio: "Lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed ", image: "People1")

        pets = [samplePet]
        selectedPet = pets.first
        user = sampleUser

        galleryItems = (1...8).map { index in
            GalleryItem(id: UUID(), image: "gallery\(index)", isVideo: index % 3 == 0)
        }
    }
}
