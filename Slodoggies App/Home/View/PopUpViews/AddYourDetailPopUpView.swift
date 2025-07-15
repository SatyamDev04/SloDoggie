//
//  AddYourDetailPopUpView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 15/07/25.
//

import SwiftUI

struct AddYourDetailPopUpView: View {
    //    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var bio = ""
    @State private var isEmailVerified = false
    
    var backAction : () -> () = {}
    let petAges = ["1", "2", "3", "4", "5+"]
    let managerOptions = ["Pet Mom", "Pet Dad", "Guardian"]
    
    var body: some View {
        ZStack {
            // Background dimming
            Color(hex: "#3C3C434A").opacity(0.5)
                .ignoresSafeArea()
            
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        backAction()
                    }) {
                        Image("CancelIcon")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color.blue)
                    }
                }
                .padding(.top)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 25) {
                    
                    
                    Text("Add Your Details")
                        .font(.custom("Outfit-Medium", size: 18))
                        .padding(.bottom, 4)
                    
                    Divider()
                    ScrollView{
                        VStack {
                            ZStack {
                                Image("User")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 65, height: 65)
                                    .clipShape(Circle())
                                
                                Image("UploadIcon")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .padding(4)
                                    .background(Color(hex: "#258694"))
                                    .clipShape(Circle())
                                    .offset(x: 22, y: 22)
                                
                            }
                            Text("Add Photo")
                                .font(.custom("Outfit-Medium", size: 14))
                                .padding(.top, 4)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            CustomTextField(title: "Pet Parent Name", placeholder: "Enter name", text: $name)
                            //                            CustomTextField(title: "Mobile Number", placeholder: "🇺🇸+1 (555) 123 456", text: $petBreed)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Mobile Number")
                                    .font(.custom("Outfit-Medium", size: 14))
                                HStack {
                                    Text("🇺🇸 +1")
                                        .font(.custom("Outfit-Regular", size: 15))
                                        .padding(.leading, 10)
                                    TextField("(555) 123 456", text: $phone)
                                        .font(.custom("Outfit-Regular", size: 15))
                                        .keyboardType(.numberPad)
                                        .padding(.leading, 5)
                                }
                                .frame(height: 48)
                                .background(Color(hex: "#F5F7F9"))
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
                            }
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Email")
                                    .font(.custom("Outfit-Medium", size: 14))

                                HStack {
                                    TextField("Enter email", text: $email)
                                        .font(.custom("Outfit-Regular", size: 15))
                                        .autocapitalization(.none)
                                        .disabled(isEmailVerified)

                                    if isEmailVerified {
                                        Image("Verified")
                                            .foregroundColor(.green)
                                    } else {
                                        Button(action: {
                                            // Replace this with your actual verification logic
                                            withAnimation {
                                                isEmailVerified = true
                                            }
                                        }) {
                                            Text("verify")
                                                .font(.custom("Outfit-Regular", size: 15))
                                                .foregroundColor(Color(hex: "#258694"))
                                        }
                                    }
                                }
                                .padding(.horizontal, 12)
                                .frame(height: 48)
                                .background(Color(hex: "#F5F7F9"))
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
                            }

                            CustomTextField(title: "Bio", placeholder: "Enter Bio...", text: $bio)
                        }
                        
                        HStack {
                            Button("Skip") {
                                backAction()
                            }
                            .font(.custom("Outfit-Medium", size: 16))
                            .foregroundColor(.black)
                            .frame(minWidth: 150)
                            
                            Spacer()
                            
                            Button(action: {
                                backAction()
                            }) {
                                Text("Save & Continue")
                                    .font(.custom("Outfit-Medium", size: 16))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(minWidth: 150)
                                    .background(Color(hex: "#258694"))
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.top)
                    }
                }
                .scrollIndicators(.hidden)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal)
                //            .padding(.bottom)
            }
        }
    }
}

#Preview {
    AddYourDetailPopUpView()
}
