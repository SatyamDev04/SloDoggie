//
//  PhoneNumberLoginViewModel.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/07/25.
//

import Foundation
import SwiftUI
import Combine

class EmailLoginViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var alertPresnt: Bool = false
    
    @Published var email: String = "" {
        didSet {
            validateEmail()
        }
    }
    @Published var emailError: String?
    @Published var isEmailValid: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
    func validateEmail() -> Bool {
        if email.isEmpty {
            emailError = "Email cannot be empty"
            isEmailValid = false
            return false
        } else if !isValidEmail(email) {
            emailError = "Invalid email format"
            isEmailValid = false
            return false
        } else {
            emailError = nil
            isEmailValid = true
            return true
        }
    }

    
//    func validateFields() -> Bool  {
//       if !isValidEmail(email) {
//            emailError = "Invalid email format"
//            isEmailValid = false
//        } else {
//            emailError = nil
//            isEmailValid = true
//        }
//        return true
//    }
    
}

