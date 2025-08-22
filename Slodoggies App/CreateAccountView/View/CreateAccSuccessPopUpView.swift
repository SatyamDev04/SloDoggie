//
//  CreateAccSuccessPopUpView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/08/25.
//

import SwiftUI

struct CreateAccSuccessPopUpView: View {
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
                Image("CongratulationIcon")
                    .resizable()
                    .frame(width: 55, height: 55)
                    .padding(.top, 33)
                
                Text("Are you sure you want to log out of your account?")
                    .font(.custom("Outfit-Regular", size: 16))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                

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
    CreateAccSuccessPopUpView(isPresented: .constant(true))
}

