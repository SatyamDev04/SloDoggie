//
//  EditProfileViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/07/25.
//

import Foundation
import SwiftUI
import Combine

class EditProfileViewModel: ObservableObject {
    @Published var parentName: String = ""
    @Published var mobileNumber: String = "" {
        didSet {
            // Auto-toggle verified status correctly
            if mobileNumber == verifiedNum {
                isPhoneVerified = true     // re-entered verified number
            } else {
                isPhoneVerified = false    // changed to something else
            }
        }
    }
    @Published var email: String = ""{
        didSet {
            // Auto-toggle verified status correctly
            if email == verifiedEmail {
                isEmailVerified = true     // re-entered verified number
            } else {
                isEmailVerified = false    // changed to something else
            }
        }
    }
    @Published var relationToPet: String = ""
    @Published var Bio: String = ""
    @Published var imgData: Data = Data()
    @Published var selectedImage: UIImage?
    @Published var profileImage: String = ""
    
    @Published var OTP: Int? = nil
    
    let ageOptions = ["1", "2", "3", "4", "5", "6", "7+"]
    let managedByOptions = ["Pet Mom", "Pet Dad", "Guardian", "Other"]

    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false
    private var cancellables = Set<AnyCancellable>()
    @Published var showActivity = false
    
    @Published var isPhoneValid: Bool = false
    @Published var isEmailValid: Bool = false
    @Published var verifiedNum = ""
    @Published var verifiedEmail = ""
    @Published var isPhoneVerified: Bool = false
    @Published var isEmailVerified: Bool = false
    
    init(){
        self.getYourDetailApi()
    }
    func saveChanges() {
        // Perform API call or local save logic
        print("Saving Pet Profile")
    }
    
    func validateForm(skipBackAction: Bool = false) -> Bool {
        if parentName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter parent name")
            return false
        }
        if mobileNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter mobile no.")
            return false
        }
        if isPhoneVerified == false{
            showErrorPopup("Enter verified mobile no.")
            return false
        }
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter email")
            return false
        }
        if isEmailVerified == false{
            showErrorPopup("Enter verified email")
            return false
        }
        if Bio.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter bio")
            return false
        }
//        if relationToPet.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//            showErrorPopup("Enter managed by")
//            return false
//        }
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
    
    func showErrorPopup(_ message: String) {
        errorMessage = message
        showError = true
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
                    self.profileImage = response.data?.image ?? ""
                    self.parentName = response.data?.name ?? ""
                    self.mobileNumber = response.data?.phone ?? ""
                    self.verifiedNum = response.data?.phone ?? ""
                    self.verifiedEmail = response.data?.email ?? ""
                    self.email = response.data?.email ?? ""
                    self.Bio = response.data?.bio ?? ""
                    
                    if let phone = response.data?.phone, !phone.isEmpty {
                        self.isPhoneVerified = true
                    }
                    
                    if let email = response.data?.email, !email.isEmpty {
                        self.isEmailVerified = true
                    }
                    
                }else{
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                }
                
            }.store(in: &cancellables)
        
    }
    
    func editYourDetailApi(completion: @escaping (Bool) -> Void) {
        self.showActivity = true
        APIManager.shared.AddYourDetailApi(name: self.parentName, email: self.email, phone: self.mobileNumber, bio: self.Bio, imgData: ["profile_image": imgData])
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
        APIManager.shared.sendEmailPhoneOtp(email_Phone: Email_phone)
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
