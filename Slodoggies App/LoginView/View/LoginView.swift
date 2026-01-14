//
//  PhoneNumberView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/07/25.
//


import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginsViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
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
                        Text("Login")
                            .font(.custom("Outfit-SemiBold", size: 18))
                            .foregroundColor(.black)
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Email/Phone")
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(.black)
                            .padding(.leading, 30)
                        
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
                            if viewModel.isInputValid {
                                Image("")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .padding(.trailing, 16)
                                    .transition(.opacity)
                            }
                        }
                        .animation(.easeInOut, value: viewModel.inputError)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.horizontal,30)
                        
                        if let inputError = viewModel.inputError {
                            Text(inputError)
                                .foregroundColor(.red)
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal,30)
                        }
                        
                        Text("Password")
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(.black)
                            .padding(.top)
                            .padding(.leading, 30)
                        
                        HStack {
                            Group {
                                if isPasswordVisible {
                                    TextField("Enter Password", text: $viewModel.password)
                                        .font(.custom("Outfit-Regular", size: 14))
                                } else {
                                    SecureField("Enter Password", text: $viewModel.password)
                                        .font(.custom("Outfit-Regular", size: 14))
                                }
                            }
                            
                            Button(action: { isPasswordVisible.toggle() }) {
                                Image(isPasswordVisible ? "openeyeimg" : "closeeyeimg")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .frame(height: 50)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.horizontal, 30)
                        
                        // Show the error:
                        if let passwordError = viewModel.passwordError {
                            Text(passwordError)
                                .foregroundColor(.red)
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal,30)
                        }
                    }
                    
                    // Forgot Password
                    HStack {
                        Spacer()
                        Button("Forgot Password?") {
                            //coordinator.isBackGestureEnabled = true
                            UserDefaults.standard.set("forgotPassword", forKey: "signUp")
                            coordinator.push(.forgotPassword)
                            // navigateToForgotPassword = true
                        }
                        .font(.custom("Outfit-Medium", size: 14))
                        .foregroundColor(.black)
                        .padding(.top, -15)
                    }
                    .padding(.horizontal, 30)
                    
                    Button(action: {
                       
                        if viewModel.validateFieldsBeforeLogin() {
                            UserDefaults.standard.set("save", forKey: "saveLogin")
                            UserDefaults.standard.set("loginSuccess", forKey: "loginSuccess")
                            viewModel.loginApi { success in
                                if success{
                                    coordinator.push(.tabBar)
                                }
                            }
                        } else {
                            // Prefer passwordError if it exists, else inputError
                            if let pwdError = viewModel.passwordError {
                                viewModel.errorMessage = pwdError
                            } else if let inputError = viewModel.inputError {
                                viewModel.errorMessage = inputError
                            } else {
                                viewModel.errorMessage = "Invalid input."
                            }
                            viewModel.isPresentAlert = true
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text("Login")
                                .foregroundColor(.white)
                                .font(.custom("Outfit-Medium", size: 15))
                            Spacer()
                        }
                        .padding()
                        .background(Color(hex: "#258694"))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal,30)
                    
                    Button(action: {
                        
                    }) {
                        HStack(spacing: 4){
                            Text("New here?")
                                .font(.custom("Outfit-Medium", size: 14))
                                .foregroundColor(Color(hex: "#949494"))
                            Button(action: {
                                //coordinator.isBackGestureEnabled = true
                                UserDefaults.standard.set("signUp", forKey: "signUp")
                                coordinator.push(.createAccountView)
                                // navigateToSignUp = true
                            }) {
                                Text("Create an Account")
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
//        .alert(isPresented: $showAlert){
//            Alert(
//                title: Text("Error"),
//                message: Text(alertMessage),
//                dismissButton: .default(Text("OK"))
//            )
//        }
    }
}

#Preview {
    LoginView()
}
