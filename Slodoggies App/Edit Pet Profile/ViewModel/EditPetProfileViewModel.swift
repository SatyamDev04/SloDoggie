//
//  EditProfileViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/07/25.
//

import Foundation
import SwiftUI

class PetProfileViewModel: ObservableObject {
    @Published var petName: String = ""
    @Published var petBreed: String = ""
    @Published var petAge: String = ""
    @Published var petBio: String = ""
    @Published var managedBy: String = ""

    @Published var selectedImage: UIImage?

    let ageOptions = ["1", "2", "3", "4", "5", "6", "7+"]
    let managedByOptions = ["Pet Mom", "Pet Dad", "Guardian", "Other"]

    func saveChanges() {
        // Perform API call or local save logic
        print("Saving Pet Profile")
    }
}
