//
//  AddYourDetailViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 04/11/25.
//

import SwiftUI
import Combine

class AddYourDetailViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var name: String = ""
    @Published var phone: String = ""
    @Published var email: String = ""
    @Published var bio: String = ""
    @Published var selectedImage: UIImage? = nil
    
    @Published var isPhoneVerified: Bool = false
    @Published var isEmailVerified: Bool = false
    
    @Published var ownerDetails : OwnerDetails?
    @Published var imgData: Data = Data()
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false
    private var cancellables = Set<AnyCancellable>()
    @Published var showActivity = false
    // MARK: - Validation
    @Published var OTP: Int? = nil
    @Published var isPhoneValid: Bool = false
    @Published var isEmailValid: Bool = false
    
    func validateForm() -> Bool {
        // Trimmed inputs
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPhone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedBio = bio.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Reset validation flags
        isPhoneValid = false
        isEmailValid = false
        
        // MARK: - Name
        guard !trimmedName.isEmpty else {
            showErrorPopup("Enter pet parent's name")
            return false
        }
        
        // MARK: - Phone
        guard !trimmedPhone.isEmpty else {
            showErrorPopup("Enter mobile number")
            return false
        }
        
        guard isValidPhone(trimmedPhone) else {
            showErrorPopup("Enter a valid phone number")
            return false
        }
        
        isPhoneValid = true
        
        // MARK: - Email
        guard !trimmedEmail.isEmpty else {
            showErrorPopup("Enter email address")
            return false
        }
        
        guard isValidEmail(trimmedEmail) else {
            showErrorPopup("Enter a valid email address")
            return false
        }
        
        isEmailValid = true
        
        // MARK: - Bio
        guard !trimmedBio.isEmpty else {
            showErrorPopup("Enter bio")
            return false
        }
        
        return true
    }
    
    // MARK: - Helpers
    func isValidPhone(_ phone: String) -> Bool {
        let regex = #"^[0-9]{10}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: phone)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let regex = #"^\S+@\S+\.\S+$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    
    private func showErrorPopup(_ message: String) {
        errorMessage = message
        showError = true
    }
    
    // MARK: - Actions
    func verifyPhone() {
        withAnimation {
            isPhoneVerified = true
        }
    }
    
    func verifyEmail() {
        withAnimation {
            isEmailVerified = true
        }
    }
    
    func setImage(_ image: UIImage?) {
        selectedImage = image
        imgData = image?.jpegData(compressionQuality: 0.8) ?? Data()
    }
    
    func getYourDetailApi() {
        self.showActivity = true
        APIManager.shared.getYourDetailApi()
            .sink { completionn in
                self.showActivity = false
                if case .failure(let error) = completionn {
                    print("Failed to send OTP with error: \(error.localizedDescription)")
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                
                if response.success  ?? false {
                    self.ownerDetails = response.data
                    self.name = self.ownerDetails?.name ?? ""
//                    self.phone = self.ownerDetails?.phone ?? ""
//                    
//                    if self.phone != ""{
//                        self.isPhoneVerified = true
//                    }
//                    self.email = self.ownerDetails?.email ?? ""
//                    if self.email != ""{
//                        self.isPhoneVerified = true
//                    }
                    
                    self.phone = self.ownerDetails?.phone ?? ""
                    self.email = self.ownerDetails?.email ?? ""

                    if let phone = self.ownerDetails?.phone, !phone.isEmpty {
                        self.isPhoneVerified = true
                    }
                    
                    if let email = self.ownerDetails?.email, !email.isEmpty {
                        self.isEmailVerified = true
                    }
                    
                }else{
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                }
                
            }.store(in: &cancellables)
        
    }
    
    func AddYourDetailApi(completion: @escaping (Bool) -> Void) {
        self.showActivity = true
        APIManager.shared.AddYourDetailApi(name: self.name, email: self.email, phone: self.phone, bio: self.bio, imgData: ["profile_image": imgData])
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
                    completion(true)
                }else{
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                    completion(false)
                }
                
            }.store(in: &cancellables)
        
    }
    
    func sendOtp(Email_phone:String, completion: @escaping (Bool) -> Void) {
        self.showActivity = true
        APIManager.shared.sendOtp(email_Phone: Email_phone, apiType: "signup")
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
                    self.OTP = response.data?.otp
                    completion(true)
                }else{
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                    completion(false)
                }
                
            }.store(in: &cancellables)
        
    }
    
}
