//
//  ProfileSuccUpdatedPopUp.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 22/07/25.
//

import SwiftUI

struct ProfileUpdatedSuccPopUp: View {
    @Binding var isVisible: Bool
    @EnvironmentObject private var coordinator: Coordinator
    var backAction : () -> () = {}
    var onRemove: () -> Void = {}
    
    var body: some View {
    // if isVisible{
        ZStack {
            // Background dimming
            Color(hex: "#3C3C434A").opacity(0.5)
                .ignoresSafeArea()
            
            VStack{
                HStack{
                    Spacer()
                         Button(action: {
                             isVisible = false
                             coordinator.pop()
                         }) {
                             Image("CancelIcon")
                                 .resizable()
                                 .frame(width: 35, height: 35)
                                 .foregroundColor(Color.blue)
                         }
                     }
                     .padding(.top)
                     .padding(.trailing, 1)
                     
                     VStack(spacing: 20) {
                         Image("ProfileSuccess")
                             .scaledToFit()
                             .frame(width: 50, height: 50, alignment: .center)
                             .foregroundColor(.blue)
                         //  .padding(.top, -20)
                         
                         Text("Profile Updated!")
                             .font(.custom("Outfit-Medium", size: 16))
                         
                         Text("""
                              Your information has been saved.
                              Thanks for keeping things up to date!
                            """
                         )
                         .font(.custom("Outfit-Regular", size: 14))
                         .multilineTextAlignment(.center)
                         .padding(.top, -10)
                         .padding(.bottom, 10)
                     }
                     .padding(.horizontal,10)
                     .frame(maxWidth: .infinity)
                     .padding(.vertical)
                     .background(Color.white)
                     .cornerRadius(20)
                 }
                 .padding(.leading, 30)
                 .padding(.trailing, 30)
                 //.padding(.bottom, 30)
             }
//         }
     }
 }

#Preview {
    ProfileUpdatedSuccPopUp(
        isVisible: .constant(true))
//        backAction: {
//            print("Popup closed")
//        }
        
}
