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
            // Background dimming
            Color(hex: "#3C3C434A").opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 20) {
                Image("Logout")
                    .resizable()
                    .frame(width: 55, height: 55)
                    .padding(.top, 33)
                
                Text("Are you sure you want to log out of your account?")
                    .font(.custom("Outfit-Regular", size: 16))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                HStack {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .font(.custom("Outfit-Medium", size: 16))
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 144, height: 42)
                    
                    Button("Logout") {
                        isPresented = false
                        print("Account logged out")
                    }
                    .padding()
                    .frame(width: 140, height: 42)
                    .font(.custom("Outfit-Bold", size: 15))
                    .foregroundColor(.white)
                    .background(Color(hex: "#258694"))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .background(Color.white)
            .cornerRadius(16)
            .padding(.horizontal, 30)
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
                .padding(.top, -60)
                .padding(.trailing, 30),
                alignment: .topTrailing
            )
        }
    }
}

#Preview {
    LogoutAccountPopUpView(isPresented: .constant(true))
}

