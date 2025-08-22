//
//  ForgotPasswordView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 18/08/25.
//

import SwiftUI

struct ForgotPasswordView: View {
    @StateObject var viewModel = PhoneNumberLoginViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
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
                .foregroundColor(Color(hex: "#949494"))
            
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    TextField("Enter Email/Phone", text: $viewModel.phoneNumber)
                        .font(.custom("Outfit-Regular", size: 14))
                        .padding()
                        .keyboardType(.numberPad)
                        .onChange(of: viewModel.phoneNumber) { newValue, _ in
                            viewModel.phoneNumError = nil
                            let digits = newValue.filter { $0.isNumber }
                            viewModel.phoneNumber = viewModel.formatAsPhoneNumber(digits)
                            viewModel.isPhoneNumberValid = digits.count >= 10
                        }
                    
                    if viewModel.isPhoneNumberValid {
                        Image("Tick")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .padding(.trailing, 16)
                            .transition(.opacity)
                    }
                }
                .animation(.easeInOut, value: viewModel.phoneNumError)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .padding(.horizontal,30)
                numberErrorText
                
            }
            Button(action: {
                viewModel.validateFields()
                coordinator.push(.verifyPhone)
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
            .padding(.horizontal,30)
            .padding(.top, 18)
            
            Button(action: {
                
            }) {
                HStack(spacing: 4) {
                    Text("Remember your password?")
                        .font(.custom("Outfit-Medium", size: 14))
                        .foregroundColor(Color(hex: "#949494"))
                    Button(action: {
                        //coordinator.isBackGestureEnabled = true
                        coordinator.push(.phoneNumberLogin)
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
    
    private var numberErrorText: some View {
        Group {
            if let numberError = viewModel.phoneNumError {
                Text(numberError)
                    .foregroundColor(.red)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 10)
                    .padding(.horizontal,30)
            }
        }
    }
}

#Preview {
    ForgotPasswordView()
}
