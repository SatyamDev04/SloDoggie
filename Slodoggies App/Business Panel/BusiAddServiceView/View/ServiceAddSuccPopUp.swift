//
//  ServiceAddSuccPopUp.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 02/09/25.
//

import SwiftUI

struct ServiceAddedSuccPopUp: View {
    @Binding var isVisible: Bool
    @EnvironmentObject private var coordinator: Coordinator
      var backAction : () -> () = {}
      var onRemove: () -> Void = {}
    var onAddAnother: () -> Void
    @EnvironmentObject var tabRouter: TabRouter
    
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
                         //  .padding(.top, -20)
                         
                         Text("Service Added Successfully")
                             .font(.custom("Outfit-Medium", size: 18))
                         
                         Text("Your service has been added.")
                             .font(.custom("Outfit-Regular", size: 14))
                             .multilineTextAlignment(.center)
                             .padding(.top, -10)
                         
                         VStack{
                             Button(action: {
                                 isVisible = false
                                 onAddAnother()   // ✅ reset form
                                
                                 
                             }) {
                                 HStack{
                                     Text("+")
                                         .font(.system(size: 20, weight: .regular, design: .default))
                                     Text("Add Another Services")
                                 }
                                         .frame(maxWidth: .infinity)
                                         .padding()
                                         .background(Color(hex: "#258694"))
                                         .foregroundColor(.white)
                                         .cornerRadius(8)
                                         .font(.custom("Outfit-Medium", size: 16))
                                 }
                             
                             .padding(.top, 10)
                             
                             Button(action: {
                                 let addService = UserDefaults.standard.string(forKey: "addService")
                                 if addService == "addService"{
                                     tabRouter.selectedTab = .home
                                     coordinator.push(.tabBar)
                                 }else{
                                     UserDefaults.standard.set("save", forKey: "saveLogin")
                                     coordinator.push(.notificationpermision)
                                 }
                             }) {
                              HStack {
                                 Image("HomeUnselected")
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(Color(hex: "#258694"))
                                     Text("Go To Home")
                                 }
                                     .frame(maxWidth: .infinity)
                                     .padding()
                                     .foregroundColor(Color(hex: "#258694"))
                                     .cornerRadius(8)
                                     .font(.custom("Outfit-Medium", size: 16))
                             }
                         }
                         .padding(.top, -10)
                         .padding(.horizontal,10)
                     }
                     .padding(.horizontal, 10)
                     .frame(maxWidth: .infinity)
                     .padding(.vertical)
                     .background(Color.white)
                     .cornerRadius(20)
                     .padding(.horizontal, 35)
                 }
             }
//         }
     }
 }

#Preview {
    ServiceAddedSuccPopUp(
        isVisible: .constant(true), onAddAnother: { })
//        backAction: {
//            print("Popup closed")
//        }
        
}
