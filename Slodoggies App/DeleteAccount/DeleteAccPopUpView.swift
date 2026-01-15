//
//  DeleteAccPopUpView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 15/07/25.
//

import SwiftUI

 struct DeleteAccountPopUpView: View {
    @State private var deleteText: String = ""
    @Binding var isPresented: Bool
    @EnvironmentObject private var coordinator: Coordinator
    
var body: some View {
    ZStack {
        ZStack {
            // Background dimming
            Color(hex: "#3C3C434A").opacity(0.5)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Trash icon
                Image("deleteIcon")
                    .resizable()
                    .frame(width: 55, height: 55)
                    .padding(.top, 33)
                
                // Title
                Text("Are you sure you want to delete your account?")
                    .font(.custom("Outfit-Regular", size: 16))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Subtext
                Text("This action is permanent and will erase all your saved reflections and progress.")
                    .font(.custom("Outfit-Regular", size: 14))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                
                VStack(alignment: .leading){
                    // Confirmation instruction
                    Text("Please type “DELETE” to confirm")
                        .font(.custom("Outfit-Regular", size: 14))
                        .foregroundColor(.black)
                        .padding(.leading)
                    
                    
                    // Text field for typing "DELETE"
                    TextField("", text: $deleteText)
                        .padding()
                        .frame(height: 45)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#949494"), lineWidth: 1)
                        )
                        .padding(.horizontal)
                }
                
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
                    
                    Button(action: {
                        isPresented = false
                        coordinator.logoutAndGoToLogin()
                        print("Account deleted")
                    }) {
                        Text("Delete")
                            .disabled(deleteText != "DELETE")
                            .font(.custom("Outfit-Bold", size: 15))
                            .padding()
                            .frame(width: 140, height: 42)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .background(Color(hex: "#258694"))
                            .cornerRadius(8, corners: .allCorners)
                    }
                }
                .padding([.horizontal])
                .padding(.bottom, 30)
            }
            .background(.white)
            .cornerRadius(16)
            .padding()
            .padding(.leading, 20)
            .padding(.trailing, 20)
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
                .padding(.trailing, 34),
                alignment: .topTrailing
            )
        }
    }
  }
}
  

 #Preview{
     DeleteAccountPopUpView(isPresented: .constant(true))
 }
