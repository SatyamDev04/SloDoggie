//
//  LoginView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 13/08/25.
//


import SwiftUI

struct CreateAccountView: View {
    @StateObject var viewModel = CreateAccountViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        ZStack {
            VStack {
                HStack{
                    Button(action: {
                        coordinator.pop()
                    }) {
                        Image("Back")
                            .foregroundColor(Color(hex: "#258694"))
                            .padding(.top, 5)
                    }
                    Spacer()
                }
                .padding(.leading, 25)
                .padding(.trailing, 25)
                // Spacer()
                
                ScrollView{
                    VStack {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color(hex: "#258694"))
                            .frame(width: 87, height: 6)
                            .padding()
                        
                        Text("Create your account")
                            .font(.custom("Outfit-SemiBold", size: 18))
                            .foregroundColor(.black)
                    }
                    // .padding()
                    
                    VStack(alignment: .leading) {
                        let userType = UserDefaults.standard.string(forKey: "userType")
                        if userType == "Professional" {
                            Text("Full Name")
                                .font(.custom("Outfit-Medium", size: 14))
                                .foregroundColor(.black)
                                .padding(.horizontal,30)
                            TextField("Enter Full Name", text: $viewModel.fullName)
                                .font(.custom("Outfit-Regular", size: 14))
                                .padding()
                                .frame(height: 50)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled(true)
                                .onChange(of: viewModel.fullName) {  _,_ in
                                    viewModel.emailError = nil
                                    
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                )
                                .padding(.horizontal,30)
                            
                        }else{
                            Text("Full Name")
                                .font(.custom("Outfit-Medium", size: 14))
                                .foregroundColor(.black)
                                .padding(.horizontal,30)
                            TextField("Enter Full Name", text: $viewModel.fullName)
                                .font(.custom("Outfit-Regular", size: 14))
                                .padding()
                                .frame(height: 50)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled(true)
                                .onChange(of: viewModel.fullName) {  _,_ in
                                    viewModel.emailError = nil
                                    
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                )
                                .padding(.horizontal,30)
                        }
                    }
                    .padding(.top)
                    
                    VStack(alignment: .leading) {
                        Text("Email/ Phone")
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(.black)
                        
                        TextField("Enter Email/ Phone", text: $viewModel.userInput)
                            .font(.custom("Outfit-Regular", size: 14))
                            .padding()
                            .frame(height: 50)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled(true)
                            .onChange(of: viewModel.userInput) { newValue in
                                // If input is all digits → enforce max 10
                                if newValue.allSatisfy({ $0.isNumber }) {
                                    if newValue.count > 10 {
                                        viewModel.userInput = String(newValue.prefix(10))
                                    }
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                        
                    }
                    .padding(.horizontal,30)
                    .padding(.top)
                    if let inputError = viewModel.inputError {
                        Text(inputError)
                            .foregroundColor(.red)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal,30)
                    }
                    
                    
                    VStack(alignment: .leading) {
                        Text("Password")
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(.black)
                        
                        HStack {
                            if viewModel.isPasswordVisible {
                                TextField("Enter Password", text: $viewModel.password)
                                    .font(.custom("Outfit-Regular", size: 14))
                                    .padding()
                                    .frame(height: 50)
                                    .onChange(of: viewModel.password) {  _,_ in
                                        viewModel.passwordError = nil
                                        
                                    }
                            } else {
                                SecureField("Enter Password", text: $viewModel.password)
                                    .font(.custom("Outfit-Regular", size: 14))
                                    .padding()
                                    .frame(height: 50)
                                    .onChange(of: viewModel.password) { _,_ in
                                        viewModel.passwordError = nil
                                    }
                            }
                            
                            Button(action: {
                                viewModel.isPasswordVisible.toggle()
                            }) {
                                Image(viewModel.isPasswordVisible ? "openeyeimg" : "closeeyeimg")
                                    .foregroundColor(.gray)
                                    .frame(width: 10, height: 10)
                            }
                            
                            .padding(.trailing, 16)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        
                        passwordErrorText
                    }
                    .padding(.horizontal,30)
                    .padding(.top)
                    
                    VStack(alignment: .leading) {
                        Text("Confirm Password")
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(.black)
                        
                        HStack {
                            if viewModel.isConfirmPasswordVisible {
                                TextField("Re-enter Password", text: $viewModel.confirmPassword)
                                    .font(.custom("Outfit-Regular", size: 14))
                                    .padding()
                                    .frame(height: 50)
                                    .onChange(of: viewModel.confirmPassword) {  _,_ in
                                        viewModel.confirmPasswordError = nil
                                        
                                    }
                            } else {
                                SecureField("Re-enter Password", text: $viewModel.confirmPassword)
                                    .font(.custom("Outfit-Regular", size: 14))
                                    .padding()
                                    .frame(height: 50)
                                    .onChange(of: viewModel.confirmPassword) { _,_ in
                                        viewModel.confirmPasswordError = nil
                                        
                                    }
                            }
                            
                            Button(action: {
                                viewModel.isConfirmPasswordVisible.toggle()
                            }) {
                                Image(viewModel.isConfirmPasswordVisible ? "openeyeimg" : "closeeyeimg")
                                    .foregroundColor(.gray)
                                    .frame(width: 10, height: 10)
                            }
                            
                            .padding(.trailing, 16)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        confirmPasswordErrorText
                    }
                    .padding(.horizontal,30)
                    .padding(.top)
                    
                    VStack(spacing: 10){
                        Button(action: {
                        if viewModel.validateFields(){
                            viewModel.sendOtp { success in
                                if success{
                                    if userData.role == .professional{
                                        coordinator.push(.businessRegisteration)
                                    }else{
                                        coordinator.push(.verifyPhone(viewModel.profileData))
                                    }
                                }
                            }
                        }
                        }) {
                            Text("Create Account")
                                .foregroundColor(.white)
                                .font(.custom("Outfit-Medium", size: 15))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "#258694"))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal,30)
                        HStack{
                            Text("Already have an account?")
                                .font(.custom("Outfit-Medium", size: 14))
                                .foregroundColor(Color(hex: "#949494"))
                            
                            Button(action: {
                                coordinator.pop()
                            }) {
                                Text("Login")
                                    .font(.custom("Outfit-Medium", size: 14))
                                    .foregroundColor(Color(hex: "#258694"))
                                    .underline()
                                    .padding(.leading, -6)
                            }
                        }
                        .padding(.top, 10)
                    }
                    .padding(.top)
                    TermsTextView()
                      .padding(.top, 10)
                
                //Spacer()
                
                HStack {
                    Spacer()
                    Image("PawImg")
                        .padding(.bottom, 12)
                }
                .padding(.trailing)
                .padding(.top)
              }
            }
            if viewModel.showAccountCreatedPop{
                AccountCreatedSuccessPopUpView(onCancel: {
                    viewModel.showAccountCreatedPop = false
                    if userData.role == .professional{
                        coordinator.push(.businessRegisteration)
                    }else{
                        coordinator.push(.notificationpermision)
                    }
                })
            }
            if viewModel.showActivity {
                CustomLoderView(isVisible: $viewModel.showActivity)
                    .ignoresSafeArea()
            }
        }
        .alert(isPresented: $viewModel.isPresentAlert) {
            Alert(title: Text(viewModel.errorMessage ?? ""))
        }
//        .alert(isPresented: $viewModel.showPopup) {
//            Alert(title: Text("Validation Error"), message: Text(viewModel.popupMessage), dismissButton: .default(Text("OK")))
//        }
    }
    
    private var numberErrorText: some View {
        Group {
            if let emailError = viewModel.emailError {
                Text(emailError)
                    .foregroundColor(.red)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 10)
            }
        }
    }
    
    private var passwordErrorText: some View {
        Group {
            if let passError = viewModel.passwordError {
                Text(passError)
                    .lineLimit(2)
                    .foregroundColor(.red)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .frame(height: 10)
            }
        }
    }
    private var confirmPasswordErrorText: some View {
        Group {
            if let passError = viewModel.confirmPasswordError {
                Text(passError)
                    .foregroundColor(.red)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 10)
            }
         }
     }
  }

import SwiftUI

struct TermsTextView: View {
    @EnvironmentObject private var coordinator: Coordinator

    var body: some View {
        Text(makeAttributedString())
            .font(.custom("Outfit-Regular", size: 14))
            .multilineTextAlignment(.center)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 40)   // increased leading/trailing space
            .padding(.top, 10)
            // Intercept taps on the AttributedString links and route via coordinator
            .environment(\.openURL, OpenURLAction { url in
                // Note: use custom app:// scheme to detect internal navigation
                if url.scheme == "app" {
                    switch url.host {
                    case "terms":
                        coordinator.push(.termsAndCondition)
                        return .handled
                    case "privacy":
                        coordinator.push(.privacyPolicy)
                        return .handled
                    default:
                        return .systemAction
                    }
                }
                // For other URLs, let the system handle them (or customize)
                return .systemAction
            })
    }

    private func makeAttributedString() -> AttributedString {
        var string = AttributedString("By creating an account, you agree to our Terms & Conditions and Privacy Policy.")
        
        if let range = string.range(of: "Terms & Conditions") {
            string[range].foregroundColor = Color(hex: "#258694")
            string[range].underlineStyle = .single
            // custom scheme so we can intercept the tap
            string[range].link = URL(string: "app://terms")!
        }
        
        if let range = string.range(of: "Privacy Policy") {
            string[range].foregroundColor = Color(hex: "#258694")
            string[range].underlineStyle = .single
            string[range].link = URL(string: "app://privacy")!
        }
        
        return string
    }
}

#Preview {
    CreateAccountView()
}
