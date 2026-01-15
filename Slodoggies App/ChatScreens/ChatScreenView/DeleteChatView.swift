//
//  DeleteChatView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 11/08/25.
//

import SwiftUI

struct DeleteChatPopUpView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
            ZStack {
                // Background dimming
                Color(hex: "#3C3C434A").opacity(0.5)
                    .ignoresSafeArea()
                
                VStack(spacing: 10) {
                    // Trash icon
                    Image("deleteIcon")
                        .resizable()
                        .frame(width: 55, height: 55)
                        .padding(.top, 33)
                    
                    Text("Delete Conversation")
                        .font(.custom("Outfit-Regular", size: 16))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Title
                    Text("Are you sure you want to delete this conversation? This action cannot be undone.")
                        .font(.custom("Outfit-Regular", size: 14))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Buttons
                    HStack {
                        Button(action: {
                            isPresented = false
                        }) {
                            Text("Delete")
                                .padding()
                                .frame(width: 140, height: 42)
                                .font(.custom("Outfit-Bold", size: 15))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .background(Color(hex: "#258694"))
                                .cornerRadius(8, corners: .allCorners)
                        }
                        
                        //Spacer()
                        Button("Cancel") {
                            isPresented = false
                            print("Account deleted")
                            //isPresented = false
                        }
                        .font(.custom("Outfit-Medium", size: 16))
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 144, height: 42)
                    }
                    .padding([.horizontal])
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                }
                .background(.white)
                .cornerRadius(16)
                .padding()
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .overlay(
                    // Cross button in top-right corner of popup
                    Button(action: {
                        isPresented = false
                    }) {
                        Image("crossIcon")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(8)
                        //.background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                        .padding(.top, -40)
                        .padding(.trailing, 50),
                    alignment: .topTrailing
                )
                //.offset(x: 10, y: -10)
            }
        }
     }


 #Preview{
     DeleteChatPopUpView(isPresented: .constant(true))
 }
