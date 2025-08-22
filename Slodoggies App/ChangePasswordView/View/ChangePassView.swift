//
//  ChangePassView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 18/08/25.
//

import SwiftUI

struct ChangePasswordView: View {
    @StateObject var viewModel = CreateAccViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var repeatPassword: String = ""
    @State private var isrepeatPasswordVisible: Bool = false
    @State private var showPopUp: Bool = false
    
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
                Text("New Password")
                    .font(.custom("Outfit-SemiBold", size: 18))
                    .foregroundColor(.black)

            }

            VStack(alignment: .leading, spacing: 10) {
                Text("New Password")
                    .font(.custom("Outfit-Medium", size: 14))
                    .foregroundColor(.black)
                    .padding(.top)
                    .padding(.leading, 30)
                    
                
                HStack {
                    if isPasswordVisible {
                        TextField("Enter Password", text: $password)
                            .font(.custom("Outfit-Regular", size: 14))
                    } else {
                        SecureField("Enter Password", text: $password)
                            .font(.custom("Outfit-Regular", size: 14))
                    }
                    
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(isPasswordVisible ? "openeyeimg" : "openeyeimg")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.white)
                .frame(height: 50)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .padding(.horizontal,30)
            
            
            Text("Confirm Password")
                .font(.custom("Outfit-Medium", size: 14))
                .foregroundColor(.black)
                .padding(.top)
                .padding(.leading, 30)
                
            
            HStack {
                if isrepeatPasswordVisible {
                    TextField("Re-enter Password", text: $repeatPassword)
                        .font(.custom("Outfit-Regular", size: 14))
                } else {
                    SecureField("Re-enter Password", text: $repeatPassword)
                        .font(.custom("Outfit-Regular", size: 14))
                }
                
                Button(action: {
                    isrepeatPasswordVisible.toggle()
                }) {
                    Image(isrepeatPasswordVisible ? "openeyeimg" : "openeyeimg")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.white)
            .frame(height: 50)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
            .padding(.horizontal,30)
        }
        
            Button(action: {
                viewModel.validateFields()
                coordinator.push(.verifyPhone)
            }) {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showPopUp = true
                    }) {
                        Text("Update Password")
                            .foregroundColor(.white)
                            .font(.custom("Outfit-Medium", size: 15))
                    }
                        Spacer()
                    }
                    .padding()
                    .background(Color(hex: "#258694"))
                    .cornerRadius(10)
                }
                .padding(.horizontal,30)
                .padding(.top)
                
            Spacer()

            HStack {
                Spacer()
                Image("PawImg")
                    .padding(.bottom, 12)
            }
            .padding(.horizontal)
        }
        .padding(.top, -30)
        .overlay(
            Group {
                if showPopUp{
                    PasswordUpdateSuccPopUpView(isVisible: $showPopUp)
                }
            }
        )
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
    ChangePasswordView()
}
