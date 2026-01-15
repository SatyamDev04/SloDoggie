//
//  ForgotPassViewModal.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 03/10/25.
//

import Foundation
import SwiftUI
import Combine

class ForgetViewModel: ObservableObject {
    
    @Published var userInput: String = "" {
        didSet { validateInput(userInput) }
    }
    @Published var inputError: String? = nil
    @Published var isInputValid: Bool = false

    @Published var password: String = "" {
        didSet { validatePassword(password) }   // auto-validate when it changes
    }
    @Published var passwordError: String? = nil
    @Published var isPasswordValid: Bool = false

    @Published var isPresentAlert = false
    @Published var showActivity = false
    
    @Published var profileData = profileDetails()
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

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
        APIManager.shared.sendOtp(email_Phone: self.userInput, apiType: "forgot")
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
                    self.profileData.email_Phone = response.data?.emailOrPhone
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
