//
//  BusiEventCreatedPopUp.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 17/09/25.
//

import SwiftUI

struct BusiEventCreatedPopUp: View {
    @Binding var isVisible: Bool
    @EnvironmentObject var tabRouter: TabRouter
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
                             tabRouter.selectedTab = .home
                             tabRouter.isTabBarHidden = false
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
                         
                         Text("Event Created!")
                             .font(.custom("Outfit-Medium", size: 17))
                         
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
    BusiEventCreatedPopUp(
        isVisible: .constant(true))
//        backAction: {
//            print("Popup closed")
//        }
        
}
