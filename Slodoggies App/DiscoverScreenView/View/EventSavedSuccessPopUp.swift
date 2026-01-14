//
//  EventSavedSuccessPopUp.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 10/09/25.
//

import SwiftUI

struct EventSavedSuccessPopUp: View {
    @Binding var isVisible: Bool
    @EnvironmentObject private var coordinator: Coordinator
    
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
                             .frame(width: 55, height: 55)
                             .foregroundColor(.blue)
                    //       .padding(.top, -20)
                         
                         Text("Event Saved!")
                             .font(.custom("Outfit-Medium", size: 18))
                         
                         Text("Your event has been successfully added — we can’t wait for you and your furry friends to join the fun!")
                             .font(.custom("Outfit-Regular", size: 16))
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
    EventSavedSuccessPopUp(
        isVisible: .constant(true))
//        backAction: {
//            print("Popup closed")
//        }
        
}

