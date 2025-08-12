//
//  RemoveFollowerPopUpView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/07/25.
//

//
//  CongratsFreeConsPopupView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 15/07/25.
//


import SwiftUI

struct RemoveFollowerPopUp: View {
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
                         
                         Image("RemoveUser")
                             .scaledToFit()
                             .frame(width: 50, height: 50)
                             .foregroundColor(.blue)
                         //                         .padding(.top, -20)
                         
                         Text("Remove Follower?")
                             .font(.custom("Outfit-Medium", size: 17))
                         
                         Text("We won’t tell Zain Dorwart they were removed from your followers.")
                             .font(.custom("Outfit-Regular", size: 15))
                             .multilineTextAlignment(.center)
                         
                         HStack {
                             Button("Cancel") {
                                 isVisible = false
                             }
                             .font(.custom("Outfit-Medium", size: 16))
                             .foregroundColor(.black)
                             .padding()
                             .frame(width: 144, height: 42)
                             
                             //Spacer()
                             
                             Button("Remove") {
                                 print("Account deleted")
                                 isVisible = false
                                 onRemove()
                             }
                             .padding()
                             .frame(width: 140, height: 42)
                             .font(.custom("Outfit-Bold", size: 15))
                             .foregroundColor(.white)
                             .cornerRadius(8)
                             .background(Color(hex: "#258694"))
                             .cornerRadius(8, corners: .allCorners)
                         }
                         .padding([.horizontal])

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
    RemoveFollowerPopUp(
        isVisible: .constant(true))
//        backAction: {
//            print("Popup closed")
//        }
        
}
