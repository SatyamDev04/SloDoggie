//
//  LogoutAccountView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 16/07/25.
//

import SwiftUI

struct LogoutAccountPopUpView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            ZStack {
                // Background dimming
                Color(hex: "#3C3C434A").opacity(0.5)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Trash icon
                    Image("Logout")
                        .resizable()
                        .frame(width: 55, height: 55)
                        .padding(.top, 33)
                    
                    // Title
                    Text("Are you sure you want to log out of your account?")
                        .font(.custom("Outfit-Regular", size: 16))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Buttons
                    HStack {
                        Button("Cancel") {
                            isPresented = false
                        }
                        .font(.custom("Outfit-Medium", size: 16))
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 144, height: 42)
                        
                        //Spacer()
                        
                        Button("Logout") {
                            isPresented = false
                            print("Account deleted")
                            //isPresented = false
                        }
                        .padding()
                        .frame(width: 140, height: 42)
                        .font(.custom("Outfit-Bold", size: 15))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .background(Color(hex: "#258694"))
                        .cornerRadius(8, corners: .allCorners)
                    }
                    .padding([.horizontal])
                    .padding(.bottom, 30)
                }
                .background(.white)
                .cornerRadius(16)
                .padding()
                .padding(.leading, 20)
                .padding(.trailing, 20)
                
            }
            
            Button(action: {
                isPresented = false
            }) {
                Image("crossIcon")
                    .resizable()
                    .frame(width: 38, height: 38)
                    .background(Color.white.clipShape(Circle()))
                    .padding(.top, -155)
                    .padding(.leading, 270)
            }
            .offset(x: 10, y: -10)
        }
     }
  }

 #Preview{
     LogoutAccountPopUpView(isPresented: .constant(true))
 }
