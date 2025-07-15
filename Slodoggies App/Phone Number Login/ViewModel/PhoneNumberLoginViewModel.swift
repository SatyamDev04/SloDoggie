//
//  PhoneNumberLoginViewModel.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/07/25.
//

import Foundation
import SwiftUI
import Combine

class PhoneNumberLoginViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var alertPresnt: Bool = false
    
    @Published var phoneNumber : String = ""
    @Published var phoneNumError: String?
    @Published var isPhoneNumberValid: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
   
    func validateFields() -> Bool {
        var isValid = true

        if phoneNumber.isEmpty {
            phoneNumError = "Phone number cannot be empty"
            isValid = false
        } else if phoneNumber.count < 10 {
            phoneNumError = "Phone enter valid number"
            isValid = false
        }else {
            phoneNumError = nil
        }
        return isValid
    }
    
    func formatAsPhoneNumber(_ number: String) -> String {
        let cleaned = number.filter { $0.isNumber }.prefix(10) // Only digits, max 10
        var result = ""
        for (index, char) in cleaned.enumerated() {
            if index == 3 || index == 6 {
                result.append(" ")
            }
            result.append(char)
        }
        return result
    }
    
}

