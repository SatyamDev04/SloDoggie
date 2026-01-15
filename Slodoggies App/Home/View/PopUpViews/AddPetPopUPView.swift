//
//  Untitled.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 25/08/25.
//

import SwiftUI

struct AddPetPopUPView: View {
    @Binding var isVisible: Bool
    var continueAction: () -> Void = {} // NEW: call this when Continue pressed
    var backAction : () -> () = {}
    
    var body: some View {
        ZStack {
            Color(hex: "#3C3C434A").opacity(0.5).ignoresSafeArea()
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        isVisible = false
                    }) {
                        Image("CancelIcon")
                            .resizable()
                            .frame(width: 35, height: 35)
                    }
                }
                .padding(.top)
                .padding(.trailing,45)
                
                VStack(spacing: 20) {
                    Image("addpet")
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    
                    Text("Add Pet")
                        .font(.custom("Outfit-Medium", size: 18))
                    
                    Text("Want to add more pets? You may do so in your profile")
                        .font(.custom("Outfit-Regular", size: 14))
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        isVisible = false
                        continueAction()
                        backAction()
                        // Tell parent to open AddYourDetailPopUpView
                    }) {
                        Text("Continue adding Parent Profile")
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#258694"))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal,10)
                .frame(width: 320)
                .padding(.vertical)
                .background(Color.white)
                .cornerRadius(10)
            }
        }
    }
}

#Preview {
    AddPetPopUPView(isVisible: .constant(true))
}
