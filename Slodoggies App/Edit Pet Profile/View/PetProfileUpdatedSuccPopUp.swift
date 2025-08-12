//
//  PetProfileUpdatedSuccPopUp.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 22/07/25.
//

import SwiftUI

struct PetProfileUpdatedSuccPopUp: View {
    @Binding var isVisible: Bool
      var backAction : () -> () = {}
      var onRemove: () -> Void = {}
    
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
                         
                         Image("ProfileSuccess")
                             .scaledToFit()
                             .frame(width: 50, height: 50)
                             .foregroundColor(.blue)
                    //       .padding(.top, -20)
                         
                         Text("Pet Profile Updated!")
                             .font(.custom("Outfit-Medium", size: 17))
                         
                         Text("Your pet information has been saved.Thanks for keeping things up to date!")
                             .font(.custom("Outfit-Regular", size: 15))
                             .multilineTextAlignment(.center)
                         
                     }
                     .padding(.horizontal,10)
                     .frame(width: 320)
                     .padding(.vertical)
                     .background(Color.white)
                     .cornerRadius(20)
                 }
                 
             }
//         }
     }
 }
#Preview {
    PetProfileUpdatedSuccPopUp(
        isVisible: .constant(true))
//        backAction: {
//            print("Popup closed")
//        }
        
}
