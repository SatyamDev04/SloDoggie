//
//  CongratsFreeConsPopupView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 15/07/25.
//


import SwiftUI

struct WelcomePopUp: View {
    
//    @Binding var isVisible: Bool
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
//                             isVisible = false
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
                         //                         .padding(.top, -20)
                         
                         Text("Welcome to SloDoggies!")
                             .font(.custom("Outfit-Medium", size: 18))
                         
                         Text("We're excited you're here!  Rather than excited to have you. Thanks")
                             .font(.custom("Outfit-Regular", size: 15))
                             .multilineTextAlignment(.center)
                         
                         Button(action: {
//                             isVisible = false
                             backAction()
                         }) {
                             Text("Get Started")
                                 .foregroundColor(.white)
                                 .frame(maxWidth: .infinity)
                                 .padding()
                                 .background(Color(hex: "#258694"))
                                 .cornerRadius(8)
                         }
                     }
                     .padding(.horizontal,10)
                     .frame(width: 320)
                     .padding(.vertical)
                     .background(Color.white)
                     .cornerRadius(24)
                 }
             }
//         }
     }
 }
#Preview {
    WelcomePopUp(
//        isVisible: .constant(true)
//        backAction: {
//            print("Popup closed")
//        }
    )
}
