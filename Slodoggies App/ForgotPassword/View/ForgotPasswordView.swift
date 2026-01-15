//
//  ForgotPasswordView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 18/08/25.
//

import SwiftUI

struct ForgotPasswordView: View {
    @StateObject var viewModel = ForgetViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        ZStack{
            VStack{
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
                        Text("Forgot Password?")
                            .font(.custom("Outfit-SemiBold", size: 18))
                            .foregroundColor(.black)
                        
                    }
                    
                    Text("Please enter your Email to get a verification code")
                        .font(.custom("Outfit-Medium", size: 15))
                        .foregroundColor(Color(hex: "#9C9C9C"))
                    
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            TextField("Enter Email/Phone", text: $viewModel.userInput)
                                .font(.custom("Outfit-Regular", size: 14))
                                .padding()
                                .keyboardType(.emailAddress) // supports both email + phone
                                .autocapitalization(.none)
                                .onChange(of: viewModel.userInput) { newValue in
                                    // If input is all digits → enforce max 10
                                    if newValue.allSatisfy({ $0.isNumber }) {
                                        if newValue.count > 10 {
                                            viewModel.userInput = String(newValue.prefix(10))
                                        }
                                    }
                                }
                            // Commented on 12 nov
                            //                    if viewModel.isInputValid {
                            //                        Image("Tick")
                            //                            .resizable()
                            //                            .frame(width: 15, height: 15)
                            //                            .padding(.trailing, 16)
                            //                            .transition(.opacity)
                            //                    }
                        }
                        .animation(.easeInOut, value: viewModel.inputError)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.horizontal,30)
                        
                        // Show the error:
                        if let inputError = viewModel.inputError {
                            Text(inputError)
                                .foregroundColor(.red)
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal,30)
                        }
                        //numberErrorText
                        
                    }
                    Button(action: {
                        // Validate only the input
                        viewModel.validateInput(viewModel.userInput)
                        
//                        if viewModel.isInputValid {
                        viewModel.sendOtp { success in
                            if success{
                                UserDefaults.standard.set("forgotPassword", forKey: "signUp")
                                coordinator.push(.verifyPhone(viewModel.profileData))
                            }
                        }
//                        } else {
//                            viewModel.errorMessage = viewModel.inputError ?? "Invalid email/phone."
//                            viewModel.isPresentAlert = true
//                        }
                    }) {
                        HStack {
                            Spacer()
                            Text("Send Code")
                                .foregroundColor(.white)
                                .font(.custom("Outfit-Medium", size: 15))
                            Spacer()
                        }
                        .padding()
                        .background(Color(hex: "#258694"))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 18)
                    
                    
                    Button(action: {
                        
                    }) {
                        HStack(spacing: 4) {
                            Text("Remember your password?")
                                .font(.custom("Outfit-Medium", size: 14))
                                .foregroundColor(Color(hex: "#9C9C9C"))
                            Button(action: {
                                //coordinator.isBackGestureEnabled = true
                                coordinator.push(.loginView)
                                // navigateToSignUp = true
                            }) {
                                Text("Log In")
                                    .underline()
                                    .font(.custom("Outfit-Medium", size: 14))
                                    .foregroundColor(Color(hex: "#258694"))
                            }
                        }
                        .padding(.top, 10)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Image("PawImg")
                            .padding(.bottom, 12)
                    }
                    .padding(.horizontal)
                }
                .padding(.top, -30)
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
}

#Preview {
    ForgotPasswordView()
}
