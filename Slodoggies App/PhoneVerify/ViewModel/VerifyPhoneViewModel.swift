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
    
    let phoneNumber = "7568498248"
    
    @Published var isPresentAlert = false
    @Published var showActivity = false
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    
    var isCodeComplete: Bool {
        otp.count == 4
    }
    
    func verifyOtp(fullName:String,email_Phone: String, pwd: String, userType: String, otp: String, completion: @escaping (Bool) -> Void) {
        self.showActivity = true
        
           
        APIManager.shared.userRegisterAPi(fullName: fullName, emailOrPhone: email_Phone, password: pwd, fcm_token: UserDetail.shared.getFcmToken(), userType: userType, otp: otp)
            .sink { completionn in
                self.showActivity = false
                if case .failure(let error) = completionn {
                    print("Login failed with error: \(error.localizedDescription)")
                    self.isPresentAlert = true
                    self.errorMessage = error.localizedDescription
                    completion(false)
                }
            } receiveValue: { response in
                
                if response.success  ?? false {
//                    self.dataResponse = response.data
                    //                    self.userDefaultManager.addItem(key: .authToken, item:  self.dataResponse?.token ?? "")
                    UserDetail.shared.setTokenWith(response.data?.token ?? "")
                    UserDetail.shared.setName(response.data?.user?.name ?? "")
                    UserDetail.shared.setEmailId(response.data?.user?.email ?? "")
//                    UserDetail.shared.setProfileImg(response.data?.user?.profileImage ?? "")
                    UserDetail.shared.setUserId("\(response.data?.user?.id ?? 0)")
//                    UserDetail.shared.setCountryCode(response.data?.user?.countryCode ?? "")
                    UserDetail.shared.setphoneNo(response.data?.user?.phone ?? "")
                    completion(true)
                }else{
                    self.isPresentAlert = true
                    self.errorMessage = response.message ?? "Something went wrong"
                    completion(false)
                }
                
            }.store(in: &cancellables)
        
    }
    
    func verifyForgetOtp(email_Phone: String, otp: String, completion: @escaping (Bool) -> Void) {
        self.showActivity = true
        
        APIManager.shared.ForgetOtpVerifyAPi(emailOrPhone: email_Phone, otp: otp)
            .sink { completionn in
                self.showActivity = false
                if case .failure(let error) = completionn {
                    print("Login failed with error: \(error.localizedDescription)")
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
    
    func verifyEmailPhoneOtp(email_Phone: String,otp: String, completion: @escaping (Bool) -> Void) {
        self.showActivity = true
        
           
        APIManager.shared.verifyEmailPhoneOtp(email_Phone: email_Phone,otp: otp)
            .sink { completionn in
                self.showActivity = false
                if case .failure(let error) = completionn {
                    print("Login failed with error: \(error.localizedDescription)")
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
