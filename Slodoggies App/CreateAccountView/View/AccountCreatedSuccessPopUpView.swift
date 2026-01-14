//
//  AccountCreatedSuccessPopUpView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 13/08/25.
//

import SwiftUI

struct AccountCreatedSuccessPopUpView: View {
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
                        Image("crossIcon")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color.blue)
                    }
                }
                .padding(.top)
                .padding(.trailing,40)
                
                VStack(spacing: 20) {
                    Image("CongratulationIcon")
                        .scaledToFit()
                        .frame(width: 55, height: 55)
                        .foregroundColor(.blue)
                    
                    Text("Account Created Successfully!")
                        .font(.custom("Outfit-Medium", size: 18))
                    
                }
                .frame(width: 320)
                .padding(.vertical, 45)
                .background(Color.white)
                .cornerRadius(10)
            }
        }
    }
}

#Preview {
    AccountCreatedSuccessPopUpView()
}
