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
            ZStack {
                // Background dimming
                Color(hex: "#3C3C434A").opacity(0.5)
                    .ignoresSafeArea()
                
                VStack(spacing: 10) {
                    // Trash icon
                    Image("delete")
                        .resizable()
                        .frame(width: 55, height: 55)
                        .padding(.top, 33)
                    
                    Text("Delete Conversation")
                        .font(.custom("Outfit-Regular", size: 16))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Title
                    Text("Are you sure you want to delete this conversation? This action cannot be undone.")
                        .font(.custom("Outfit-Regular", size: 16))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Buttons
                    HStack {
                        Button("Delete") {
                            isPresented = false
                        } .padding()
                            .frame(width: 140, height: 42)
                            .font(.custom("Outfit-Bold", size: 15))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .background(Color(hex: "#258694"))
                            .cornerRadius(8, corners: .allCorners)
                        
                        
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
                    .padding(.bottom, 30)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                }
                .background(.white)
                .cornerRadius(16)
                .padding()
                .padding(.leading, 40)
                .padding(.trailing, 40)
                
            }
            
            Button(action: {
                isPresented = false
            }) {
                Image("crossIcon")
                    .resizable()
                    .frame(width: 38, height: 38)
                    .background(Color.white.clipShape(Circle()))
                    .padding(.top, -160)
                    .padding(.leading, 250)
            }
            .offset(x: 10, y: -10)
        }
     }
  }

 #Preview{
     DeleteChatPopUpView(isPresented: .constant(true))
 }
