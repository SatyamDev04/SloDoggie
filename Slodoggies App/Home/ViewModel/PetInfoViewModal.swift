//
//  PetInfoViewModal.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 05/09/25.
//
import SwiftUI
import Combine
import UIKit

final class PetInfoViewModel: ObservableObject {
    // MARK: - Input fields
    @Published var petName: String = ""
    @Published var petBreed: String = ""
    @Published var petAge: String = ""
    @Published var petBio: String = ""
    @Published var managedBy: String = "Pet Mom"
    @Published var selectedImage: UIImage? = nil

    // MARK: - States
    @Published var showAgePicker: Bool = false
    @Published var showManagerPicker: Bool = false
    @Published var showActionSheet: Bool = false
    @Published var showImagePicker: Bool = false
    @Published var isPresented: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showPetsList: Bool = false
    @Published var addPetTapCount: Int = 0
    @Published var selectedPet: PetsDetailData? = nil
    @Published var imgData: Data = Data()
    
    private var cancellables = Set<AnyCancellable>()
    @Published var showActivity = false
    
    
    @Published var pets = [PetsDetailData]()

    // MARK: - Picker options
    let petAges = ["< than 1 year", "1 Year", "2 Years", "3 Years", "4 Years", "5 Years", "6 Years", "7 Years", "8 Years", "9 Years", "10 Years", "11 Years", "12 Years", "13 Years", "14 Years", "15 Years", "16 Years", "17 Years", "18 Years", "19 Years", "20 Years"]
    let managerOptions = ["Pet Mom", "Pet Dad", "Guardian"]

    // MARK: - Validation
    func validateForm(skipBackAction: Bool = false) -> Bool {
        if petName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter pet name")
            return false
        }
        if petBreed.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter pet breed")
            return false
        }
        if petAge.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Select pet age")
            return false
        }
        if petBio.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter pet bio")
            return false
        }
        return true
    }

    private func showErrorPopup(_ message: String) {
        errorMessage = message
        showError = true
    }

    // MARK: - Add Pet logic
    func addPetAction() {
        addPetTapCount += 1

        if addPetTapCount == 1 {
            showPetsList = true
//            let newPet = Pets(name: petName, imageName: "User",petImg: self.selectedImage)
//            pets.append(newPet)
            clearFields()
        } else if addPetTapCount >= 2 {
            isPresented = true
            addPetTapCount = 0
        }
    }

    func clearFields() {
        petName = ""
        petBreed = ""
        petAge = ""
        petBio = ""
        managedBy = "Pet Mom"
        selectedImage = UIImage(named: "User")
    }
    
    func addPetApi(completion: @escaping (Bool) -> Void) {
        guard validateForm(skipBackAction: true) else { return }
        self.showActivity = true
        APIManager.shared.addPetApi(petName: self.petName, petBreed: self.petBreed, petAge: self.petAge, petBio: self.petBio, imgData: ["pet_image": self.imgData], petId: "")
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
                    self.pets.append(response.data ?? PetsDetailData(id: 0, ownerUserID: 0, petName: "", petBreed: "", petAge: "", petImage: "", petBio: "", createdAt: "", updatedAt: "", deletedAt: ""))
                    completion(true)
                }else{
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                    completion(false)
                }
                
            }.store(in: &cancellables)
        
    }
    
}
