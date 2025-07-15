//
//  VerifyPhoneViewModel.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/07/25.
//

import Foundation
import Combine

class VerifyPhoneViewModel: ObservableObject {
    @Published var timerValue: Int = 25
    @Published var showTimer: Bool = false
    @Published var resendEnabled = true
    @Published var otp: String = ""  // <-- Store OTP input here
    
    let phoneNumber = "+1 555 123 456"
    
    var isCodeComplete: Bool {
        otp.count == 4
    }
}
