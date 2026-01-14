//
//  ChangePassView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 18/08/25.
//

import SwiftUI

struct ChangePasswordView: View {
    
    let userDeatils: profileDetails
    @StateObject var viewModel = ChangePassViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    @State private var showPopUp: Bool = false
    
    init(userDeatils: profileDetails? = nil) {
        self.userDeatils = userDeatils ?? profileDetails()
        print(self.userDeatils)
    }
    
    var body: some View {
        ZStack {
            VStack {
                // MARK: - Back Button
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
                    
                    Text("New Password")
                        .font(.custom("Outfit-SemiBold", size: 18))
                        .foregroundColor(.black)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        
                        // MARK: - New Password Field
                        Text("New Password")
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(.black)
                            .padding(.leading, 30)
                        
                        HStack {
                            if viewModel.isPasswordVisible {
                                TextField("Enter Password", text: $viewModel.password)
                                    .font(.custom("Outfit-Regular", size: 14))
                                    .autocapitalization(.none)
                            } else {
                                SecureField("Enter Password", text: $viewModel.password)
                                    .font(.custom("Outfit-Regular", size: 14))
                            }
                            
                            Button(action: {
                                viewModel.isPasswordVisible.toggle()
                            }) {
                                Image(viewModel.isPasswordVisible ? "openeyeimg" : "closeeyeimg")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(viewModel.passwordError == nil ? Color.gray.opacity(0.5) : Color.red, lineWidth: 1)
                        )
                        .onChange(of: viewModel.password) { _ in
                            viewModel.validateFields()
                        }
                        .padding(.horizontal, 30)
                        
                        if let error = viewModel.passwordError {
                            Text(error)
                                .font(.custom("Outfit-Regular", size: 12))
                                .foregroundColor(.red)
                                .padding(.leading, 30)
                        }
                        
                        // MARK: - Confirm Password Field
                        Text("Confirm Password")
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(.black)
                            .padding(.leading, 30)
                        
                        HStack {
                            if viewModel.isConfirmPasswordVisible {
                                TextField("Re-enter Password", text: $viewModel.confirmPassword)
                                    .font(.custom("Outfit-Regular", size: 14))
                                    .autocapitalization(.none)
                            } else {
                                SecureField("Re-enter Password", text: $viewModel.confirmPassword)
                                    .font(.custom("Outfit-Regular", size: 14))
                            }
                            
                            Button(action: {
                                viewModel.isConfirmPasswordVisible.toggle()
                            }) {
                                Image(viewModel.isConfirmPasswordVisible ? "openeyeimg" : "closeeyeimg")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(viewModel.confirmPasswordError == nil ? Color.gray.opacity(0.5) : Color.red, lineWidth: 1)
                        )
                        .onChange(of: viewModel.confirmPassword) { _ in
                            viewModel.validateFields()
                        }
                        .padding(.horizontal, 30)
                        
                        if let error = viewModel.confirmPasswordError {
                            Text(error)
                                .font(.custom("Outfit-Regular", size: 12))
                                .foregroundColor(.red)
                                .padding(.leading, 30)
                        }
                    }
                    
                    // MARK: - Update Password Button
                    Button(action: {
                        if viewModel.validateFields() {
                            if let email = userDeatils.email_Phone {
                                viewModel.changePasswordApi(emailPhone: email) { success in
                                    if success {
                                        showPopUp = true
                                    }
                                }
                            } else {
                                print("❌ email_Phone is nil")
                            }
                        }

                    }) {
                        Text("Update Password")
                            .foregroundColor(.white)
                            .font(.custom("Outfit-Medium", size: 15))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#258694"))
                            .cornerRadius(10)
                            .padding(.horizontal, 30)
                    }
                    .padding(.top, 30)
                    
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
        .overlay(
            Group {
                if showPopUp {
                    PasswordUpdateSuccPopUpView(isVisible: $showPopUp)
                }
            }
        )
    }
}

#Preview {
    ChangePasswordView()
}
