//
//  ProfileSubmittedPopUpView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/08/25.
//


import SwiftUI

struct ProfileSubmittedPopUpView: View {
    var onCancel: () -> Void = {}
    var body: some View {
        ZStack {
            Color(hex: "#3C3C434A").opacity(0.5)
                .ignoresSafeArea()
            
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        onCancel()
                    }) {
                        Image("CancelIcon")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color.blue)
                    }
                }
                .padding(.top)
                .padding(.trailing,45)
                
                VStack(spacing: 20) {
                    
                    Image("SandWatch")
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                    
                    Text("Profile Submitted!")
                        .font(.custom("Outfit-Medium", size: 18))
                    
                    Text("Business profile submitted, please wait for admin approval to continue your service activity.")
                        .font(.custom("Outfit-Regular", size: 14))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                }
                .frame(width: 320)
                .padding(.vertical,20)
                .background(Color.white)
                .cornerRadius(10)
            }
            
        }
    }
}

#Preview {
    ProfileSubmittedPopUpView()
}
