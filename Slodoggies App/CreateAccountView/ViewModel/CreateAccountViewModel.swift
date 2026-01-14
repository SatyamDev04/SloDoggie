//
//  CreateAccountViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 18/08/25.
//

import Foundation
import SwiftUI
import Combine
import RealityKit

class CreateAccountViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var alertPresnt: Bool = false
    @Published var userInput: String = "" {
        didSet { validateInput(userInput) }
    }
    // Fields
    @Published var fullName: String = ""
    @Published var fullNameError: String?
    
    @Published var email: String = ""
    @Published var emailError: String?
    @Published var emailValidate: Bool = false
    
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var passwordError: String?
    @Published var passwordValidate: Bool = false
    
    @Published var confirmPassword: String = ""
    @Published var isConfirmPasswordVisible: Bool = false
    @Published var confirmPasswordError: String?
    @Published var confirmPasswordValidate: Bool = false
    @Published var isPasswordValid: Bool = false
    
    // 🔹 Popups
    @Published var showAccountCreatedPop: Bool = false
   
    @Published var inputError: String? = nil
    @Published var isInputValid: Bool = false
    
    @Published var isPresentAlert = false
    @Published var showActivity = false
    
    @Published var profileData = profileDetails()
    
    private var cancellables = Set<AnyCancellable>()
    
    private func isValidPhone(_ phone: String) -> Bool {
        let phoneRegex = "^[0-9]{10}$"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
    }
    
    func validateInput(_ input: String) {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            inputError = "Please enter email/ phone number."
            isInputValid = false
            return
        }
        if isValidEmail(trimmed) || isValidPhone(trimmed) {
            inputError = nil
            isInputValid = true
        } else {
            inputError = trimmed.contains("@") ? "Please enter a valid email address/ phone number." : "Please enter a valid email address/ phone number."
            isInputValid = false
        }
    }

    func validateFields() -> Bool {
        var isValid = true
        var missingFields: [String] = []

        fullNameError = nil
        emailError = nil
        passwordError = nil
        confirmPasswordError = nil

        // 🔹 Full name
        if fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            fullNameError = "Full name cannot be empty"
            missingFields.append("Full Name")
            isValid = false
        }

        // 🔹 Email / Phone
        validateInput(userInput)
        if !isInputValid {
            emailError = inputError ?? "Please enter a valid email/phone"
            missingFields.append("Email/Phone")
            isValid = false
        }

        // 🔹 Password
        if password.isEmpty {
            passwordError = "Password cannot be empty"
            missingFields.append("Password")
            isValid = false
        } else if !isStrongPassword(password) {
            passwordError = "Password must be 8–12 chars, include uppercase, lowercase, number & symbol"
            isValid = false
        }

        // 🔹 Confirm Password
        if confirmPassword.isEmpty {
            confirmPasswordError = "Confirm password cannot be empty"
            missingFields.append("Confirm Password")
            isValid = false
        } else if confirmPassword != password {
            confirmPasswordError = "Passwords do not match"
            isValid = false
        }

        if !isValid {
            errorMessage = missingFields.isEmpty
                ? "Please correct highlighted fields"
                : "Please fill: \(missingFields.joined(separator: ", "))"
            isPresentAlert = true
        }

        return isValid
    }
    
    // 🔹 Helpers
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
    private func isStrongPassword(_ password: String) -> Bool {
        // Regex: 8–12 chars, at least 1 upper, 1 lower, 1 digit, 1 special char
        let passwordRegEx = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[^A-Za-z\\d]).{8,12}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegEx).evaluate(with: password)
    }
    
    func validatePassword(_ password: String) {
        let trimmed = password.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            passwordError = "Password cannot be empty."
            isPasswordValid = false
            return
        }
        
        // === Strict rule (upper + lower + digit + special + 8+) ===
        let strictRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        
        // === Example: looser rule (min 8 and at least one digit) ===
        let looserRegex = "^(?=.*\\d).{8,}$"
        
        let regexToUse = strictRegex // switch to looserRegex if you want easier requirements
        
        if NSPredicate(format: "SELF MATCHES %@", regexToUse).evaluate(with: trimmed) {
            passwordError = nil
            isPasswordValid = true
        } else {
            // Friendly message listing requirements
            passwordError = "Password must be at least 8 characters and include upper, lower, number, and a special character."
            isPasswordValid = false
        }
    }
    func validateFieldsBeforeLogin() -> Bool {
        // ✅ First validate Email/Phone
        validateInput(userInput)
        guard isInputValid else { return false }
        
        // ✅ Then validate Password (only if first field is valid)
        validatePassword(password)
        return isPasswordValid
    }
    
    func sendOtp(completion: @escaping (Bool) -> Void) {
        self.showActivity = true
        APIManager.shared.sendOtp(email_Phone: self.userInput, apiType: "signup")
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
                    self.profileData.fullName = self.fullName
                    self.profileData.email_Phone = self.userInput
                    self.profileData.password = self.password
                    self.profileData.otp = response.data?.otp
                    completion(true)
                }else{
                    self.isPresentAlert = true
                    self.errorMessage = response.message ?? "Something went wrong"
                    completion(false)
                }
                
            }.store(in: &cancellables)
        
    }
    
}
