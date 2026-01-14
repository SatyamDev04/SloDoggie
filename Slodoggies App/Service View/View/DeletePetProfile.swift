//
//  DeletePetProfile.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 16/09/25.
//

import SwiftUI

struct DeletePetProfile: View {
    @Binding var isPresented: Bool
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        ZStack {
            // Background dimming
            Color(hex: "#3C3C434A").opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 16) {
                Image("fluent_delete-48-regular")
                    .resizable()
                    .frame(width: 55, height: 55)
                    .padding(.top, 33)
                
                Text("Delete Pet Profile?")
                    .font(.custom("Outfit-Regular", size: 16))
                    .multilineTextAlignment(.center)
                   // .padding(.horizontal)
                
                VStack(spacing: 0) {
                    Text("Are you sure you want to delete this pet")
                        .font(.custom("Outfit-Regular", size: 14))
                        .multilineTextAlignment(.center)
                    //.padding(.horizontal)
                    
                    Text(" profile?")
                        .font(.custom("Outfit-Regular", size: 14))
                        .multilineTextAlignment(.center)
                    //.padding(.horizontal)
                    
                    Text("This action cannot be undone.")
                        .font(.custom("Outfit-Regular", size: 14))
                        .multilineTextAlignment(.center)
                        .padding(.top, 2)
                    //.padding(.horizontal)
                }
                
                HStack {
                    Button("Delete") {
                        isPresented = false
                        //coordinator.logoutAndGoToLogin()
                        print("Pet Deleted")
                    }
                    .padding()
                    .frame(width: 140, height: 42)
                    .font(.custom("Outfit-Bold", size: 15))
                    .foregroundColor(.white)
                    .background(Color(hex: "#258694"))
                    .cornerRadius(8)
                    
                    Button("Cancel") {
                        isPresented = false
                    }
                    .font(.custom("Outfit-Medium", size: 16))
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 144, height: 42)
                }
                .padding(.horizontal)
                .padding(.bottom, 14)
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
    DeletePetProfile(isPresented: .constant(true))
}

