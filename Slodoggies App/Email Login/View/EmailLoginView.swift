//
//  PhoneNumberView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/07/25.
//


 import SwiftUI

 struct EmailLoginView: View {
    @StateObject var viewModel = EmailLoginViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer().frame(height: 100)

            RoundedRectangle(cornerRadius: 3)
                .fill(Color(hex: "#258694"))
                .frame(width: 87, height: 6)

            VStack(spacing: 8) {
                Text("Continue With Email")
                    .font(.custom("Outfit-SemiBold", size: 18))
                    .foregroundColor(.black)

                Text("Please enter your mail to verify your account")
                    .font(.custom("Outfit-Medium", size: 14))
                    .foregroundColor(Color(hex: "#949494"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            HStack {
                TextField("Enter your mail", text: $viewModel.email)
                    .font(.custom("Outfit-Regular", size: 14))
                    .padding()
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .onChange(of: viewModel.email) { newValue, _ in
                        viewModel.emailError = nil
                    }
                if viewModel.isEmailValid {
                    Image("Tick")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(.trailing, 16)
                        .transition(.opacity) // OK to keep this now
                }
            }
            .animation(.easeInOut, value: viewModel.isEmailValid) 
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
            .padding(.horizontal,30)
            emailErrorText
            
            Button(action: {
                if viewModel.validateEmail() {
                    coordinator.push(.verifyPhone(viewModel.profileData ?? profileDetails()))
                }
            }) {
                HStack {
                    Spacer()
                    Text("Continue")
                        .font(.custom("Outfit-Medium", size: 15))
                        .foregroundColor(.white)
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
            }) {
                HStack(spacing: 8) {
                    Image("Phone")
                        .foregroundColor(.gray)
                    Text("Continue with Phone")
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
    
    private var emailErrorText: some View {
        Group {
            if let numberError = viewModel.emailError {
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
     LoginView()
   }
