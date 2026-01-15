//
//  PasswordUpdateSuccPopUp.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 18/08/25.
//

import SwiftUI

struct PasswordUpdateSuccPopUpView: View {
    @EnvironmentObject private var coordinator: Coordinator
  
  @Binding var isVisible: Bool
    var backAction : () -> () = {}
    
     var body: some View {
//         if isVisible{
             ZStack {
                 // Background dimming
                 Color(hex: "#3C3C434A").opacity(0.5)
                     .ignoresSafeArea()
                 
                 VStack{
                     HStack{
                         Spacer()
                         Button(action: {
                             isVisible = false
                             backAction()
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
                         Image("CongratulationIcon")
                             .scaledToFit()
                             .frame(width: 50, height: 50)
                             .foregroundColor(.blue)
                         //  .padding(.top, -20)
                         
                         Text("Password Updated Successfully!")
                             .font(.custom("Outfit-Medium", size: 18))
                             .padding(.top, 0)
                         Text("Your password has been changed. ")
                             .font(.custom("Outfit-Regular", size: 14))
                             .multilineTextAlignment(.center)
                             .padding(.top, -10)
                             .padding(.bottom, -10)
                         Button(action: {
                             isVisible = false
                             coordinator.logoutAndGoToLogin()
                         }) {
                             Text("Go To Login")
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
//         }
     }
 }
#Preview {
    PasswordUpdateSuccPopUpView(isVisible: .constant(true))
}
