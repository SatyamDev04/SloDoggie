//
//  EditProfileViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/07/25.
//

import Foundation
import SwiftUI

class EditProfileViewModel: ObservableObject {
    @Published var parentName: String = ""
    @Published var mobileNumber: String = ""
    @Published var email: String = ""
    @Published var relationToPet: String = ""
    @Published var Bio: String = ""

    @Published var selectedImage: UIImage?

    let ageOptions = ["1", "2", "3", "4", "5", "6", "7+"]
    let managedByOptions = ["Pet Mom", "Pet Dad", "Guardian", "Other"]

    func saveChanges() {
        // Perform API call or local save logic
        print("Saving Pet Profile")
    }
}
