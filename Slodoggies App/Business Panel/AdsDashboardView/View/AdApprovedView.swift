//
//  AdApprovedView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 14/10/25.
//

import SwiftUI

struct AdApprovedView: View {
//   @Binding var isVisible: Bool
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
                     }
                     .padding(.top)
                     .padding(.trailing,45)
                     
                     VStack(spacing: 20) {
                         Image("ProfileSuccess")
                             .scaledToFit()
                             .frame(width: 50, height: 50)
                             .foregroundColor(.blue)
                         //  .padding(.top, -20)
                         
                         Text("Your ad has been approved!")
                             .font(.custom("Outfit-Medium", size: 18))
                         
                         Text("Congratulations! Your ad is now live and visible to users on the platform.")
                             .font(.custom("Outfit-Regular", size: 15))
                             .multilineTextAlignment(.center)
                         
                         Text("You can:\n- View performance in the dashboard\n- Edit or stop your ad anytime")
                             .font(.custom("Outfit-Regular", size: 15))
                             .multilineTextAlignment(.center)
                         
                         Button(action: {
//                             isVisible = false
                             backAction()
                         }) {
                             Text("Proceed to pay.")
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
                     .cornerRadius(10)
                 }
             }
//         }
     }
 }
#Preview {
    AdApprovedView(
//        isVisible: .constant(true)
//        backAction: {
//            print("Popup closed")
//        }
    )
}
