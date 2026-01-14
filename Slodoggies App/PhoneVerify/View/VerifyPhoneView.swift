//
//  VerifyPhoneView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/07/25.
//

import SwiftUI

struct VerifyPhoneView: View {
    
    let userDeatils: profileDetails
    @StateObject var viewModel = VerifyPhoneViewModel()
    @StateObject var viewModels = CreateAccountViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject var verificationData: verifiedData
    @EnvironmentObject var userData: UserData
    
    init(userDeatils: profileDetails? = nil) {
        
        self.userDeatils = userDeatils ?? profileDetails()
        print(self.userDeatils)
        
    }
    var body: some View {
        ZStack {   // Main container ZStack
            VStack {
                // Your existing Verify screen UI
                HStack(spacing: 10){
                    Button(action: {
                        coordinator.pop()
                    }) {
                        Image("Back")
                            .foregroundColor(Color(hex: "#258694"))
                            .padding(.top, 10)
                    }
                    Spacer()
                }
                .padding(.leading, 24)
                
                VStack(spacing: 24) {
                    Spacer().frame(height: 100)
                    
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(hex: "#258694"))
                        .frame(width: 87, height: 6)
                    
                    VStack(spacing: 8) {
                        Text("Verify Your Account")
                            .font(.custom("Outfit-SemiBold", size: 18))
                        
                        Text("Please enter the 4 digit code sent to")
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(Color(hex: "#9C9C9C"))
                        
                        Text(userDeatils.email_Phone ?? "")
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(Color(hex: "#258694"))
                    }
                    
                    OTPFieldView(numberOfFields: 4, otp: $viewModel.otp)
                    
                    if viewModel.showTimer {
                        Text("00:\(String(format: "%02d", viewModel.timerValue))")
                            .font(.custom("Outfit-Medium", size: 14))
                    }
                    
                    HStack(spacing: 4) {
                        Text("Didn’t receive the code?")
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(Color(hex: "#9C9C9C"))
                        
                        if !viewModel.showTimer {
                            Button("Resend") {
                                viewModel.timerValue = 60
                                viewModel.showTimer = true
                                viewModel.resendEnabled = false
                                startTimer()
                            }
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(Color(hex: "#258694"))
                        } else {
                            Text("Resend")
                                .font(.custom("Outfit-Medium", size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Button(action: {
                        UIApplication.shared.hideKeyboard()
                        print("Verifying with OTP: \(viewModel.otp)")
                        let userType = UserDefaults.standard.string(forKey: "userType")
                        let signUp = UserDefaults.standard.string(forKey: "signUp")
                        UserDefaults.standard.set("loginSuccess", forKey: "loginSuccess")
                        
                        
                        if userType == "Professional" {
                            //  coordinator.push(.businessRegisteration)
                            if signUp == "profile"{
                                viewModel.verifyForgetOtp(email_Phone: self.userDeatils.email_Phone ?? "", otp: viewModel.otp) { success in
                                    if success{
                                        coordinator.popToHome()
                                    }
                                }
                            }else{
                                viewModel.verifyOtp(fullName: self.userDeatils.fullName ?? "", email_Phone: self.userDeatils.email_Phone ?? "", pwd: self.userDeatils.password ?? "", userType: userType ?? "", otp: viewModel.otp) { success in
                                    if success{
                                        viewModels.showAccountCreatedPop = true
                                    }
                                }
                            }
                        }else{
                            if signUp == "signUp" {
                                viewModel.verifyOtp(fullName: self.userDeatils.fullName ?? "", email_Phone: self.userDeatils.email_Phone ?? "", pwd: self.userDeatils.password ?? "", userType: userType ?? "", otp: viewModel.otp) { success in
                                    if success{
                                        viewModels.showAccountCreatedPop = true
                                    }
                                }
                            } else if signUp == "VerifyEmailPhone"{
                                viewModel.verifyEmailPhoneOtp(email_Phone: self.userDeatils.email_Phone ?? "", otp: viewModel.otp) { success in
                                    if success{
                                        verificationData.emailVerified = true
                                        coordinator.pop(value: "Verified")
                                    }
                                }
                            }else {
                                viewModel.verifyForgetOtp(email_Phone: self.userDeatils.email_Phone ?? "", otp: viewModel.otp) { success in
                                    if success{
                                        coordinator.push(.changePasswordView(userDeatils))
                                    }
                                }
                                
                            }
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text("Verify OTP")
                                .foregroundColor(
                                    viewModel.isCodeComplete ? Color.white : Color(hex: "#686868")
                                )
                            Spacer()
                        }
                        .padding()
                        .font(.custom("Outfit-Medium", size: 15))
                        .foregroundColor(Color(hex: "#686868"))
                        .background(
                            viewModel.isCodeComplete ? Color(hex: "#258694") : Color(hex: "#D9D9D9")
                        )
                        .cornerRadius(10)
                    }
                    .disabled(!viewModel.isCodeComplete)
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Image("PawImg")
                            .padding(.bottom, 12)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            
            // ✅ Full-screen popup overlay
            if viewModels.showAccountCreatedPop {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                AccountCreatedSuccessPopUpView(onCancel: {
                    withAnimation {
                        viewModels.showAccountCreatedPop = false
                    }
                    
                    let userType = UserDefaults.standard.string(forKey: "userType")
                    let signUp = UserDefaults.standard.string(forKey: "signUp")
                    
                    print(userData.role ?? "", "userData.role")
                    print(userType ?? "", "userType")
                    UserDetail.shared.setFistLogin(true)
                    if userType == "Professional" {
                        coordinator.push(.businessRegisteration)
                    } else {
                        coordinator.push(.notificationpermision)
                    }
                })
                .transition(.scale)
                .zIndex(1)
            }
            if viewModel.showActivity {
                CustomLoderView(isVisible: $viewModel.showActivity)
                    .ignoresSafeArea()
            }
        }
        .alert(isPresented: $viewModel.isPresentAlert) {
            Alert(title: Text(viewModel.errorMessage ?? ""))
        }
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if viewModel.timerValue > 0 {
                viewModel.timerValue -= 1
            } else {
                viewModel.showTimer = false
                viewModel.resendEnabled = true
                timer.invalidate()
            }
        }
    }
}

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    VerifyPhoneView()
}
