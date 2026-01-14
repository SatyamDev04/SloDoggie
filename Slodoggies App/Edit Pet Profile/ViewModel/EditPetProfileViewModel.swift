//
//  EditProfileViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/07/25.
//

import Foundation
import SwiftUI
import Combine

class PetProfileViewModel: ObservableObject {
    @Published var petName: String = ""
    @Published var petBreed: String = ""
    @Published var petAge: String = ""
    @Published var petBio: String = ""

    @Published var selectedImage: UIImage?
    @Published var imgData: Data = Data()
    
    @Published var imageSource: UIImagePickerController.SourceType = .photoLibrary
    @Published var showActionSheet = false
    @Published var showManagerPicker = false
    
    @Published var isPresented: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    @Published var showActivity = false
    
    
    let ageOptions = ["1", "2", "3", "4", "5", "6", "7+"]
    let managedByOptions = ["Pet Mom", "Pet Dad", "Guardian", "Other"]

    
    func addPetApi(name:String, breed:String, age: String, bio:String,petId:String , completion: @escaping (Bool) -> Void) {
        self.showActivity = true
        APIManager.shared.addPetApi(petName: name, petBreed: breed, petAge: age, petBio: bio, imgData: ["pet_image": self.imgData],petId: petId)
            .sink { completionn in
                self.showActivity = false
                if case .failure(let error) = completionn {
                    print("Failed to send OTP with error: \(error.localizedDescription)")
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                    completion(false)
                }
            } receiveValue: { response in
                
                if response.success  ?? false {
//                    self.pets.append(response.data ?? PetsDetailData(id: 0, ownerUserID: 0, petName: "", petBreed: "", petAge: "", petImage: "", petBio: "", createdAt: "", updatedAt: "", deletedAt: ""))
                    completion(true)
                }else{
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                    completion(false)
                }
                
            }.store(in: &cancellables)
        
    }
}
