//
//  VerifyPhoneViewModel.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/07/25.
//

import Foundation
import Combine

class VerifyEmailViewModel: ObservableObject {
    @Published var timerValue: Int = 25
    @Published var showTimer: Bool = false
    @Published var resendEnabled = true
    @Published var otp: String = ""  // <-- Store OTP input here
    
    let email = "user@slodoggies.com"
    
    var isCodeComplete: Bool {
        otp.count == 4
    }
}
