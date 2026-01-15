//
//  ProfileVerifiedPopUpView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/08/25.
//
import SwiftUI

struct ProfileVerifiedPopUpView: View {
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
                    
                    Image("Rejected")
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                    
                    Text("Profile Rejected")
                        .font(.custom("Outfit-Medium", size: 18))
                    
                    Text("Unfortunately, your profile could not be approved at this time. Please review your information and resubmit for verification.")
                        .font(.custom("Outfit-Regular", size: 14))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    HStack{
                        Button(action: {
                            // Submit action
                        }) {
                            Text("Contact Support")
                                .foregroundColor(.black)
                                .font(.custom("Outfit-Medium", size: 15))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .cornerRadius(10)
                        }
                        Button(action: {
                            // Submit action
                        }) {
                            Text("Try Again")
                                .foregroundColor(.white)
                                .font(.custom("Outfit-Medium", size: 15))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "#258694"))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal,10)
                }
                .frame(width: 320)
                .padding(.vertical,10)
                .background(Color.white)
                .cornerRadius(10)
            }
            
        }
    }
}

#Preview {
    ProfileVerifiedPopUpView()
}
