//
//  PhoneNumberView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/07/25.
//


import SwiftUI

struct PhoneNumberLoginView: View {
    @StateObject var viewModel = PhoneNumberLoginViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        VStack(spacing: 24) {
            
            Spacer().frame(height: 100)

            RoundedRectangle(cornerRadius: 3)
                .fill(Color(hex: "#258694"))
                .frame(width: 87, height: 6)

            VStack(spacing: 8) {
                Text("Phone Number")
                    .font(.custom("Outfit-SemiBold", size: 18))
                    .foregroundColor(.black)

                Text("Please enter your phone number to verify your account")
                    .font(.custom("Outfit-Medium", size: 14))
                    .foregroundColor(Color(hex: "#949494"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            HStack {
                TextField("Enter your phone number", text: $viewModel.phoneNumber)
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
            
            Button(action: {
                viewModel.validateFields()
                coordinator.push(.verifyPhone)
            }) {
                HStack {
                    Spacer()
                    Text("Continue")
                        .foregroundColor(.white)
                        .font(.custom("Outfit-Medium", size: 15))
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(Color(hex: "#258694"))
                .cornerRadius(10)
            }
            .padding(.horizontal,30)

            Button(action: {
                coordinator.push(.emailLogin)
            }) {
                HStack(spacing: 8) {
                    Image("mailBox")
                        .foregroundColor(.gray)
                    Text("Continue with mail")
                        .font(.custom("Outfit-Medium", size: 16))
                        .foregroundColor(.gray)
                }
            }

            Button(action: {
                coordinator.pop()
            }) {
                Image("Back")
                    .foregroundColor(Color(hex: "#258694"))
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
    PhoneNumberLoginView()
}
