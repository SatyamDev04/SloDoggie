//
//  RemoveUserPopUpView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 18/07/25.
//

import SwiftUI

struct RemoveParticipantsPopUpView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
            ZStack {
                // Background dimming
                Color(hex: "#3C3C434A").opacity(0.5)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Trash icon
                    Image("RemoveUser")
                        .resizable()
                        .frame(width: 55, height: 55)
                        .padding(.top, 33)
                    
                    Text("Are you sure?")
                        .font(.custom("Outfit-Medium", size: 16))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.bottom, -10)
                    
                    // Title
                    Text("You want to remove Lydia Vaccaro")
                        .font(.custom("Outfit-Regular", size: 14))
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
                        Button(action: {
                            isPresented = false
                            print("Account deleted")
                        }) {
                            Text("Remove")
                                .padding()
                                .frame(width: 140, height: 42)
                                .font(.custom("Outfit-Bold", size: 15))
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


#Preview {
    RemoveParticipantsPopUpView(isPresented: .constant(true))
}
