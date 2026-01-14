//
//  ChangePassViewModal.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 18/08/25.
//

import Foundation
import SwiftUI
import Combine

class ChangePassViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var alertPresnt: Bool = false
    
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var passwordError: String?
    @Published var passwordValidate: Bool = false
    
    @Published var confirmPassword: String = ""
    @Published var isConfirmPasswordVisible: Bool = false
    @Published var confirmPasswordError: String?
    @Published var confirmPasswordValidate: Bool = false
    
    @Published var showAccountCreatedPop: Bool = false
    
    @Published var isPresentAlert = false
    @Published var showActivity = false
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()

    func validateFields() -> Bool {
        var isValid = true
    
        if password.isEmpty {
            passwordError = "Create password cannot be empty"
            isValid = false
        } else if !isStrongPassword(password) {
            passwordError = "Password must be 8–12 chars, include uppercase, lowercase, number & symbol"
            isValid = false
        } else {
            passwordError = nil
        }
        
        if confirmPassword.isEmpty {
            confirmPasswordError = "Confirm password cannot be empty"
            isValid = false
        } else if confirmPassword != password {
            confirmPasswordError = "Passwords do not match"
            isValid = false
        } else {
            confirmPasswordError = nil
        }
        
        return isValid
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    private func isStrongPassword(_ password: String) -> Bool {
        // Regex: 8–12 chars, at least 1 upper, 1 lower, 1 digit, 1 special char
        let passwordRegEx = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[^A-Za-z\\d]).{8,12}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
  
    func changePasswordApi(emailPhone:String,completion: @escaping (Bool) -> Void) {
        self.showActivity = true
        APIManager.shared.resetPasswordApi(email_Phone: emailPhone, password: self.password)
            .sink { completionn in
                self.showActivity = false
                if case .failure(let error) = completionn {
                    print("Failed to send OTP with error: \(error.localizedDescription)")
                    self.isPresentAlert = true
                    self.errorMessage = error.localizedDescription
                    completion(false)
                }
            } receiveValue: { response in
                
                if response.success  ?? false {
                    completion(true)
                }else{
                    self.isPresentAlert = true
                    self.errorMessage = response.message ?? "Something went wrong"
                    completion(false)
                }
                
            }.store(in: &cancellables)
        
    }
    
}

